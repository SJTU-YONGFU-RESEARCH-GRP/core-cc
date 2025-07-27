"""
Enhanced ECC Analysis Module

This module provides comprehensive analysis capabilities for ECC benchmark results,
including performance comparisons, trend analysis, and recommendations.
"""

import json
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from typing import Dict, List, Tuple, Any, Optional
from pathlib import Path
from dataclasses import dataclass
import statistics
from scipy import stats

from benchmark_suite import BenchmarkResult


@dataclass
class AnalysisResult:
    """Results from ECC analysis."""
    
    # Overall performance rankings
    performance_rankings: Dict[str, int]
    
    # Best performing ECC for different scenarios
    best_for_scenarios: Dict[str, str]
    
    # Performance trends
    word_length_trends: Dict[str, Dict[int, float]]
    error_pattern_trends: Dict[str, Dict[str, float]]
    
    # Statistical analysis
    statistical_significance: Dict[str, Dict[str, float]]
    
    # Recommendations
    recommendations: List[str]
    
    # Performance metrics summary
    metrics_summary: Dict[str, Dict[str, float]]


class ECCAnalyzer:
    """Enhanced ECC analysis engine."""
    
    def __init__(self, benchmark_results: List[BenchmarkResult]):
        """
        Initialize the analyzer with benchmark results.
        
        Args:
            benchmark_results: List of benchmark results to analyze
        """
        self.results = benchmark_results
        self.df = self._create_dataframe()
        
    def _create_dataframe(self) -> pd.DataFrame:
        """Convert benchmark results to pandas DataFrame."""
        data = []
        for result in self.results:
            data.append({
                'ecc_type': result.ecc_type,
                'word_length': result.word_length,
                'error_pattern': result.error_pattern,
                'trials': result.trials,
                'correctable_errors': result.correctable_errors,
                'detected_errors': result.detected_errors,
                'undetected_errors': result.undetected_errors,
                'encode_time_avg': result.encode_time_avg,
                'decode_time_avg': result.decode_time_avg,
                'total_time_avg': result.total_time_avg,
                'code_rate': result.code_rate,
                'overhead_ratio': result.overhead_ratio,
                'correction_rate': result.correction_rate,
                'detection_rate': result.detection_rate,
                'success_rate': result.success_rate
            })
        return pd.DataFrame(data)
    
    def analyze_performance_rankings(self) -> Dict[str, int]:
        """
        Analyze and rank ECC types by overall performance.
        
        Returns:
            Dictionary mapping ECC type to performance rank (1 = best)
        """
        # Calculate composite performance score for each ECC type
        ecc_scores = {}
        
        for ecc_type in self.df['ecc_type'].unique():
            ecc_data = self.df[self.df['ecc_type'] == ecc_type]
            
            # Calculate weighted performance score
            avg_success_rate = ecc_data['success_rate'].mean()
            avg_code_rate = ecc_data['code_rate'].mean()
            avg_total_time = ecc_data['total_time_avg'].mean()
            
            # Normalize time (lower is better)
            max_time = self.df['total_time_avg'].max()
            normalized_time = 1 - (avg_total_time / max_time)
            
            # Composite score (higher is better)
            score = (0.5 * avg_success_rate + 
                    0.3 * avg_code_rate * 100 + 
                    0.2 * normalized_time * 100)
            
            ecc_scores[ecc_type] = score
        
        # Rank by score (higher score = better rank)
        sorted_ecc = sorted(ecc_scores.items(), key=lambda x: x[1], reverse=True)
        rankings = {ecc: rank + 1 for rank, (ecc, _) in enumerate(sorted_ecc)}
        
        return rankings
    
    def analyze_scenario_performance(self) -> Dict[str, str]:
        """
        Find the best ECC for different scenarios.
        
        Returns:
            Dictionary mapping scenario to best ECC type
        """
        scenarios = {}
        
        # Best for high reliability (success rate)
        best_reliability = self.df.groupby('ecc_type')['success_rate'].mean().idxmax()
        scenarios['high_reliability'] = best_reliability
        
        # Best for efficiency (code rate)
        best_efficiency = self.df.groupby('ecc_type')['code_rate'].mean().idxmax()
        scenarios['high_efficiency'] = best_efficiency
        
        # Best for speed (lowest total time)
        best_speed = self.df.groupby('ecc_type')['total_time_avg'].mean().idxmin()
        scenarios['high_speed'] = best_speed
        
        # Best for single bit errors
        single_bit_data = self.df[self.df['error_pattern'] == 'single']
        if not single_bit_data.empty:
            best_single = single_bit_data.groupby('ecc_type')['correction_rate'].mean().idxmax()
            scenarios['single_bit_errors'] = best_single
        
        # Best for burst errors
        burst_data = self.df[self.df['error_pattern'] == 'burst']
        if not burst_data.empty:
            best_burst = burst_data.groupby('ecc_type')['success_rate'].mean().idxmax()
            scenarios['burst_errors'] = best_burst
        
        # Best for random errors
        random_data = self.df[self.df['error_pattern'] == 'random']
        if not random_data.empty:
            best_random = random_data.groupby('ecc_type')['success_rate'].mean().idxmax()
            scenarios['random_errors'] = best_random
        
        return scenarios
    
    def analyze_word_length_trends(self) -> Dict[str, Dict[int, float]]:
        """
        Analyze how ECC performance varies with word length.
        
        Returns:
            Dictionary mapping ECC type to word length trends
        """
        trends = {}
        
        for ecc_type in self.df['ecc_type'].unique():
            ecc_data = self.df[self.df['ecc_type'] == ecc_type]
            word_length_trends = {}
            
            for word_length in sorted(ecc_data['word_length'].unique()):
                length_data = ecc_data[ecc_data['word_length'] == word_length]
                avg_success_rate = length_data['success_rate'].mean()
                word_length_trends[word_length] = avg_success_rate
            
            trends[ecc_type] = word_length_trends
        
        return trends
    
    def analyze_error_pattern_trends(self) -> Dict[str, Dict[str, float]]:
        """
        Analyze how ECC performance varies with error patterns.
        
        Returns:
            Dictionary mapping ECC type to error pattern trends
        """
        trends = {}
        
        for ecc_type in self.df['ecc_type'].unique():
            ecc_data = self.df[self.df['ecc_type'] == ecc_type]
            pattern_trends = {}
            
            for pattern in ecc_data['error_pattern'].unique():
                pattern_data = ecc_data[ecc_data['error_pattern'] == pattern]
                avg_success_rate = pattern_data['success_rate'].mean()
                pattern_trends[pattern] = avg_success_rate
            
            trends[ecc_type] = pattern_trends
        
        return trends
    
    def analyze_statistical_significance(self) -> Dict[str, Dict[str, float]]:
        """
        Perform statistical significance tests between ECC types.
        
        Returns:
            Dictionary with p-values for pairwise comparisons
        """
        significance = {}
        
        # Compare success rates between ECC types
        ecc_types = self.df['ecc_type'].unique()
        
        for i, ecc1 in enumerate(ecc_types):
            for j, ecc2 in enumerate(ecc_types):
                if i < j:  # Avoid duplicate comparisons
                    data1 = self.df[self.df['ecc_type'] == ecc1]['success_rate']
                    data2 = self.df[self.df['ecc_type'] == ecc2]['success_rate']
                    
                    # Perform t-test
                    t_stat, p_value = stats.ttest_ind(data1, data2)
                    
                    comparison_key = f"{ecc1}_vs_{ecc2}"
                    significance[comparison_key] = {
                        't_statistic': t_stat,
                        'p_value': p_value,
                        'significant': p_value < 0.05
                    }
        
        return significance
    
    def generate_recommendations(self) -> List[str]:
        """
        Generate recommendations based on analysis.
        
        Returns:
            List of recommendations
        """
        recommendations = []
        
        # Get best performers
        rankings = self.analyze_performance_rankings()
        scenarios = self.analyze_scenario_performance()
        
        # Overall best performer
        best_overall = min(rankings, key=rankings.get)
        recommendations.append(f"**Overall Best Performer:** {best_overall} ranks highest in composite performance score.")
        
        # Scenario-specific recommendations
        if 'high_reliability' in scenarios:
            recommendations.append(f"**For High Reliability:** {scenarios['high_reliability']} provides the highest success rate across all scenarios.")
        
        if 'high_efficiency' in scenarios:
            recommendations.append(f"**For High Efficiency:** {scenarios['high_efficiency']} offers the best code rate (data efficiency).")
        
        if 'high_speed' in scenarios:
            recommendations.append(f"**For High Speed:** {scenarios['high_speed']} has the fastest encoding/decoding times.")
        
        # Error pattern specific recommendations
        if 'single_bit_errors' in scenarios:
            recommendations.append(f"**For Single Bit Errors:** {scenarios['single_bit_errors']} provides the best correction rate for single bit errors.")
        
        if 'burst_errors' in scenarios:
            recommendations.append(f"**For Burst Errors:** {scenarios['burst_errors']} handles burst errors most effectively.")
        
        if 'random_errors' in scenarios:
            recommendations.append(f"**For Random Errors:** {scenarios['random_errors']} performs best under random error conditions.")
        
        # Performance insights
        avg_success_rates = self.df.groupby('ecc_type')['success_rate'].mean()
        best_success = avg_success_rates.max()
        worst_success = avg_success_rates.min()
        
        recommendations.append(f"**Performance Range:** Success rates range from {worst_success:.1f}% to {best_success:.1f}% across all ECC types.")
        
        # Efficiency insights
        avg_code_rates = self.df.groupby('ecc_type')['code_rate'].mean()
        best_efficiency = avg_code_rates.max()
        worst_efficiency = avg_code_rates.min()
        
        recommendations.append(f"**Efficiency Range:** Code rates range from {worst_efficiency:.3f} to {best_efficiency:.3f} across all ECC types.")
        
        return recommendations
    
    def generate_metrics_summary(self) -> Dict[str, Dict[str, float]]:
        """
        Generate summary metrics for each ECC type.
        
        Returns:
            Dictionary with summary metrics per ECC type
        """
        summary = {}
        
        for ecc_type in self.df['ecc_type'].unique():
            ecc_data = self.df[self.df['ecc_type'] == ecc_type]
            
            summary[ecc_type] = {
                'avg_success_rate': ecc_data['success_rate'].mean(),
                'avg_correction_rate': ecc_data['correction_rate'].mean(),
                'avg_detection_rate': ecc_data['detection_rate'].mean(),
                'avg_code_rate': ecc_data['code_rate'].mean(),
                'avg_overhead_ratio': ecc_data['overhead_ratio'].mean(),
                'avg_encode_time_ms': ecc_data['encode_time_avg'].mean() * 1000,
                'avg_decode_time_ms': ecc_data['decode_time_avg'].mean() * 1000,
                'avg_total_time_ms': ecc_data['total_time_avg'].mean() * 1000,
                'std_success_rate': ecc_data['success_rate'].std(),
                'std_code_rate': ecc_data['code_rate'].std(),
                'configurations_tested': len(ecc_data)
            }
        
        return summary
    
    def create_performance_visualizations(self, output_dir: str = "results") -> Dict[str, str]:
        """
        Create performance visualization charts.
        
        Args:
            output_dir: Directory to save charts
            
        Returns:
            Dictionary mapping chart name to file path
        """
        output_path = Path(output_dir)
        output_path.mkdir(exist_ok=True)
        
        charts = {}
        
        # Set style
        plt.style.use('seaborn-v0_8')
        sns.set_palette("husl")
        
        # 1. Overall Performance Comparison
        fig, ((ax1, ax2), (ax3, ax4)) = plt.subplots(2, 2, figsize=(15, 12))
        
        # Success Rate Comparison
        success_rates = self.df.groupby('ecc_type')['success_rate'].mean().sort_values(ascending=False)
        success_rates.plot(kind='bar', ax=ax1, color='skyblue')
        ax1.set_title('Average Success Rate by ECC Type')
        ax1.set_ylabel('Success Rate (%)')
        ax1.tick_params(axis='x', rotation=45)
        ax1.grid(True, alpha=0.3)
        
        # Code Rate Comparison
        code_rates = self.df.groupby('ecc_type')['code_rate'].mean().sort_values(ascending=False)
        code_rates.plot(kind='bar', ax=ax2, color='lightcoral')
        ax2.set_title('Average Code Rate by ECC Type')
        ax2.set_ylabel('Code Rate')
        ax2.tick_params(axis='x', rotation=45)
        ax2.grid(True, alpha=0.3)
        
        # Performance vs Efficiency Scatter
        summary = self.generate_metrics_summary()
        success_rates = [summary[ecc]['avg_success_rate'] for ecc in summary]
        code_rates = [summary[ecc]['avg_code_rate'] for ecc in summary]
        ecc_names = list(summary.keys())
        
        scatter = ax3.scatter(code_rates, success_rates, s=100, alpha=0.7)
        ax3.set_xlabel('Code Rate')
        ax3.set_ylabel('Success Rate (%)')
        ax3.set_title('Performance vs Efficiency Trade-off')
        ax3.grid(True, alpha=0.3)
        
        # Add labels
        for i, ecc in enumerate(ecc_names):
            ax3.annotate(ecc, (code_rates[i], success_rates[i]), 
                        xytext=(5, 5), textcoords='offset points', fontsize=8)
        
        # Error Pattern Performance
        error_pattern_data = self.df.groupby(['ecc_type', 'error_pattern'])['success_rate'].mean().unstack()
        error_pattern_data.plot(kind='bar', ax=ax4, width=0.8)
        ax4.set_title('Success Rate by Error Pattern')
        ax4.set_ylabel('Success Rate (%)')
        ax4.tick_params(axis='x', rotation=45)
        ax4.legend(title='Error Pattern')
        ax4.grid(True, alpha=0.3)
        
        plt.tight_layout()
        chart_path = output_path / "ecc_performance_analysis.png"
        plt.savefig(chart_path, dpi=300, bbox_inches='tight')
        plt.close()
        charts['performance_analysis'] = str(chart_path)
        
        # 2. Word Length Trends
        fig, axes = plt.subplots(2, 2, figsize=(15, 10))
        axes = axes.flatten()
        
        word_length_trends = self.analyze_word_length_trends()
        for i, (ecc_type, trends) in enumerate(word_length_trends.items()):
            if i < 4:  # Limit to 4 plots
                word_lengths = list(trends.keys())
                success_rates = list(trends.values())
                axes[i].plot(word_lengths, success_rates, marker='o', linewidth=2, markersize=6)
                axes[i].set_title(f'{ecc_type} - Word Length Trends')
                axes[i].set_xlabel('Word Length (bits)')
                axes[i].set_ylabel('Success Rate (%)')
                axes[i].grid(True, alpha=0.3)
        
        plt.tight_layout()
        chart_path = output_path / "ecc_word_length_trends.png"
        plt.savefig(chart_path, dpi=300, bbox_inches='tight')
        plt.close()
        charts['word_length_trends'] = str(chart_path)
        
        # 3. Heatmap of Performance by Configuration
        pivot_data = self.df.pivot_table(
            values='success_rate', 
            index='ecc_type', 
            columns='error_pattern', 
            aggfunc='mean'
        )
        
        plt.figure(figsize=(10, 8))
        sns.heatmap(pivot_data, annot=True, fmt='.1f', cmap='RdYlGn', cbar_kws={'label': 'Success Rate (%)'})
        plt.title('ECC Performance Heatmap by Error Pattern')
        plt.tight_layout()
        chart_path = output_path / "ecc_performance_heatmap.png"
        plt.savefig(chart_path, dpi=300, bbox_inches='tight')
        plt.close()
        charts['performance_heatmap'] = str(chart_path)
        
        return charts
    
    def run_complete_analysis(self) -> AnalysisResult:
        """
        Run complete analysis and return results.
        
        Returns:
            Complete analysis results
        """
        print("Running ECC analysis...")
        
        performance_rankings = self.analyze_performance_rankings()
        best_for_scenarios = self.analyze_scenario_performance()
        word_length_trends = self.analyze_word_length_trends()
        error_pattern_trends = self.analyze_error_pattern_trends()
        statistical_significance = self.analyze_statistical_significance()
        recommendations = self.generate_recommendations()
        metrics_summary = self.generate_metrics_summary()
        
        # Create visualizations
        charts = self.create_performance_visualizations()
        
        print(f"Analysis complete. Generated {len(charts)} visualization charts.")
        
        return AnalysisResult(
            performance_rankings=performance_rankings,
            best_for_scenarios=best_for_scenarios,
            word_length_trends=word_length_trends,
            error_pattern_trends=error_pattern_trends,
            statistical_significance=statistical_significance,
            recommendations=recommendations,
            metrics_summary=metrics_summary
        )


def save_benchmark_results(results: List[BenchmarkResult], output_dir: str = "results") -> None:
    """
    Save benchmark results to JSON file.
    
    Args:
        results: List of benchmark results to save
        output_dir: Directory to save results
    """
    output_path = Path(output_dir)
    output_path.mkdir(exist_ok=True)
    
    # Convert results to JSON-serializable format
    results_data = []
    for result in results:
        result_dict = {
            'ecc_type': result.ecc_type,
            'word_length': result.word_length,
            'error_pattern': result.error_pattern,
            'trials': result.trials,
            'correctable_errors': result.correctable_errors,
            'detected_errors': result.detected_errors,
            'undetected_errors': result.undetected_errors,
            'encode_time_avg': result.encode_time_avg,
            'decode_time_avg': result.decode_time_avg,
            'total_time_avg': result.total_time_avg,
            'code_rate': result.code_rate,
            'overhead_ratio': result.overhead_ratio,
            'correction_rate': result.correction_rate,
            'detection_rate': result.detection_rate,
            'success_rate': result.success_rate,
            'error_distribution': result.error_distribution
        }
        results_data.append(result_dict)
    
    # Save to JSON file
    results_file = output_path / "benchmark_results.json"
    with open(results_file, 'w') as f:
        json.dump(results_data, f, indent=2)
    
    print(f"📊 Saved {len(results)} benchmark results to {results_file}")


def load_benchmark_results(output_dir: str = "results") -> List[BenchmarkResult]:
    """
    Load benchmark results from JSON file.
    
    Args:
        results_file: Path to benchmark results JSON file
        
    Returns:
        List of benchmark results
    """
    results_file = Path(output_dir) / "benchmark_results.json"
    if not results_file.exists():
        print(f"Benchmark results not found at {results_file}. Please run the benchmark suite first.")
        return []

    with open(results_file, 'r') as f:
        data = json.load(f)
    
    results = []
    for item in data:
        result = BenchmarkResult(
            ecc_type=item['ecc_type'],
            word_length=item['word_length'],
            error_pattern=item['error_pattern'],
            trials=item['trials'],
            correctable_errors=item['correctable_errors'],
            detected_errors=item['detected_errors'],
            undetected_errors=item['undetected_errors'],
            encode_time_avg=item['encode_time_avg'],
            decode_time_avg=item['decode_time_avg'],
            total_time_avg=item['total_time_avg'],
            code_rate=item['code_rate'],
            overhead_ratio=item['overhead_ratio'],
            correction_rate=item['correction_rate'],
            detection_rate=item['detection_rate'],
            success_rate=item['success_rate'],
            error_distribution=item['error_distribution']
        )
        results.append(result)
    
    return results


def main() -> None:
    """Run ECC analysis on benchmark results."""
    try:
        # Load benchmark results
        results = load_benchmark_results()
        
        if not results:
            print("No benchmark results found. Please run benchmarks first.")
            return
        
        # Run analysis
        analyzer = ECCAnalyzer(results)
        analysis_result = analyzer.run_complete_analysis()
        
        # Print summary
        print("\nECC Analysis Summary")
        print("===================")
        print(f"Total configurations analyzed: {len(results)}")
        print(f"ECC types tested: {len(analysis_result.metrics_summary)}")
        
        print("\nPerformance Rankings:")
        for ecc_type, rank in sorted(analysis_result.performance_rankings.items(), key=lambda x: x[1]):
            print(f"  {rank}. {ecc_type}")
        
        print("\nBest ECC for Different Scenarios:")
        for scenario, ecc_type in analysis_result.best_for_scenarios.items():
            print(f"  {scenario}: {ecc_type}")
        
        print("\nTop Recommendations:")
        for i, rec in enumerate(analysis_result.recommendations[:5], 1):
            print(f"  {i}. {rec}")
        
    except FileNotFoundError:
        print("Benchmark results not found. Please run the benchmark suite first.")
    except Exception as e:
        print(f"Error during analysis: {e}")


if __name__ == "__main__":
    main() 