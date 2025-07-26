import json
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
from pathlib import Path
from typing import Dict, List, Any, Optional
from datetime import datetime
import re
import sys
import os

# Add parent directory to path to fix relative imports
sys.path.insert(0, str(Path(__file__).parent.parent))

from benchmark_suite import ECCBenchmarkSuite, create_default_config
from enhanced_analysis import ECCAnalyzer, load_benchmark_results
from hardware_verification import HardwareVerifier, load_verification_results

class ECCReportGenerator:
    """Generate comprehensive ECC analysis reports based on benchmark results and hardware verification."""
    
    def __init__(self, results_dir: str = "results"):
        self.results_dir = Path(results_dir)
        self.report_data = {}
        self.benchmark_results = None
        self.analysis_results = None
        self.hardware_results = None
        
    def load_benchmark_data(self) -> bool:
        """Load benchmark results and run analysis."""
        try:
            # Load benchmark results
            self.benchmark_results = load_benchmark_results()
            if not self.benchmark_results:
                print("No benchmark results found. Running benchmarks...")
                self._run_benchmarks()
                self.benchmark_results = load_benchmark_results()
            
            if self.benchmark_results:
                # Run analysis
                analyzer = ECCAnalyzer(self.benchmark_results)
                self.analysis_results = analyzer.run_complete_analysis()
                return True
            else:
                print("Failed to load or generate benchmark results.")
                return False
                
        except Exception as e:
            print(f"Error loading benchmark data: {e}")
            return False
    
    def _run_benchmarks(self) -> None:
        """Run benchmarks if not already available."""
        try:
            config = create_default_config()
            suite = ECCBenchmarkSuite(config)
            suite.run_benchmarks()
            suite.save_results(str(self.results_dir))
        except Exception as e:
            print(f"Error running benchmarks: {e}")
    
    def load_hardware_data(self) -> bool:
        """Load hardware verification results."""
        try:
            # Try to load existing verification results
            self.hardware_results = load_verification_results()
            
            if not self.hardware_results:
                print("No hardware verification results found. Running verification...")
                self._run_hardware_verification()
                self.hardware_results = load_verification_results()
            
            return self.hardware_results is not None
            
        except Exception as e:
            print(f"Error loading hardware data: {e}")
            return False
    
    def _run_hardware_verification(self) -> None:
        """Run hardware verification if not already available."""
        try:
            verifier = HardwareVerifier(results_dir=str(self.results_dir))
            results = verifier.verify_all_hardware()
            verifier.save_verification_results(results)
        except Exception as e:
            print(f"Error running hardware verification: {e}")
    
    def get_synthesis_data(self) -> Dict[str, int]:
        """Get available synthesis data from hardware verification."""
        if self.hardware_results:
            verifier = HardwareVerifier(results_dir=str(self.results_dir))
            return verifier.get_available_synthesis_data(self.hardware_results)
        return {}
    
    def get_testbench_data(self) -> Dict[str, Dict[str, Any]]:
        """Get available testbench data from hardware verification."""
        if self.hardware_results:
            verifier = HardwareVerifier(results_dir=str(self.results_dir))
            return verifier.get_available_testbench_data(self.hardware_results)
        return {}
    
    def get_benchmark_summary(self) -> Dict[str, Dict[str, float]]:
        """Get benchmark summary from analysis results."""
        if self.analysis_results:
            return self.analysis_results.metrics_summary
        return {}
    
    def get_performance_rankings(self) -> Dict[str, int]:
        """Get performance rankings from analysis results."""
        if self.analysis_results:
            return self.analysis_results.performance_rankings
        return {}
    
    def get_scenario_recommendations(self) -> Dict[str, str]:
        """Get scenario recommendations from analysis results."""
        if self.analysis_results:
            return self.analysis_results.best_for_scenarios
        return {}
    
    def get_recommendations(self) -> List[str]:
        """Get recommendations from analysis results."""
        if self.analysis_results:
            return self.analysis_results.recommendations
        return []
    
    def get_verilator_results(self) -> Dict[str, Dict[str, Any]]:
        """Get Verilator results from hardware verification."""
        return self.get_testbench_data()
    
    def generate_performance_charts(self) -> str:
        """Generate performance comparison charts from analysis results."""
        if not self.analysis_results:
            return "## Performance Charts\n\n*No benchmark data available for chart generation.*\n\n"
        
        charts_section = "## Performance Charts\n\n"
        
        # Check if analysis charts were generated
        charts_path = self.results_dir / "ecc_performance_analysis.png"
        if charts_path.exists():
            charts_section += f"![ECC Performance Analysis](ecc_performance_analysis.png)\n\n"
            charts_section += "*Comprehensive performance analysis showing success rates, code rates, and error pattern performance.*\n\n"
        
        heatmap_path = self.results_dir / "ecc_performance_heatmap.png"
        if heatmap_path.exists():
            charts_section += f"![ECC Performance Heatmap](ecc_performance_heatmap.png)\n\n"
            charts_section += "*Performance heatmap showing success rates across different ECC types and error patterns.*\n\n"
        
        trends_path = self.results_dir / "ecc_word_length_trends.png"
        if trends_path.exists():
            charts_section += f"![ECC Word Length Trends](ecc_word_length_trends.png)\n\n"
            charts_section += "*Performance trends showing how ECC performance varies with word length.*\n\n"
        
        return charts_section
    
    def generate_performance_comparison_table(self) -> str:
        """Generate a performance comparison table from benchmark results."""
        if not self.analysis_results:
            return "## Performance Comparison\n\n*No benchmark data available for performance comparison.*\n\n"
        
        summary = self.get_benchmark_summary()
        if not summary:
            return "## Performance Comparison\n\n*No benchmark summary available.*\n\n"
        
        table = "## Performance Comparison\n\n"
        table += "| ECC Type | Success Rate (%) | Correction Rate (%) | Detection Rate (%) | Code Rate | Overhead Ratio | Encode Time (ms) | Decode Time (ms) |\n"
        table += "|----------|------------------|-------------------|-------------------|-----------|----------------|------------------|------------------|\n"
        
        for ecc_type, metrics in summary.items():
            table += f"| {ecc_type} | {metrics['avg_success_rate']:.1f} | {metrics['avg_correction_rate']:.1f} | {metrics['avg_detection_rate']:.1f} | {metrics['avg_code_rate']:.3f} | {metrics['avg_overhead_ratio']:.3f} | {metrics['avg_encode_time_ms']:.3f} | {metrics['avg_decode_time_ms']:.3f} |\n"
        
        return table
    
    def generate_hardware_comparison_table(self) -> str:
        """Generate a hardware cost comparison table from synthesis results."""
        synthesis_data = self.get_synthesis_data()
        
        if not synthesis_data:
            return "## Hardware Cost Comparison\n\n*No synthesis data available. Hardware verification not completed or tools not available.*\n\n"
        
        table = "## Hardware Cost Comparison\n\n"
        table += "| Module | Area (Cells) | Relative Cost | Power Estimate |\n"
        table += "|--------|--------------|---------------|----------------|\n"
        
        if synthesis_data:
            min_cost = min(synthesis_data.values())
            
            for module, cells in synthesis_data.items():
                relative_cost = (cells / min_cost) if min_cost > 0 else 1
                power_estimate = cells * 0.1  # Rough power estimate based on cell count
                table += f"| {module} | {cells} | {relative_cost:.1f}x | {power_estimate:.1f}mW |\n"
        else:
            table += "| No synthesis data available | - | - | - |\n"
        
        return table
    
    def generate_ecc_analysis(self) -> str:
        """Generate detailed analysis of each ECC type."""
        analysis = "## Detailed ECC Analysis\n\n"
        
        # Parity ECC Analysis
        analysis += "### Parity Bit ECC\n\n"
        analysis += "**Characteristics:**\n"
        analysis += "- **Error Detection:** Single-bit error detection only\n"
        analysis += "- **Error Correction:** None\n"
        analysis += "- **Redundancy:** 1 bit per 8-bit data (12.5% overhead)\n"
        analysis += "- **Hardware Cost:** Lowest (7+8 = 15 cells)\n"
        analysis += "- **Latency:** Single cycle\n"
        analysis += "- **Power Consumption:** Minimal\n\n"
        analysis += "**Use Cases:**\n"
        analysis += "- Simple error detection in non-critical systems\n"
        analysis += "- Memory interfaces where correction is not required\n"
        analysis += "- Cost-sensitive applications\n"
        analysis += "- High-speed data transmission\n\n"
        
        # Hamming SECDED Analysis
        analysis += "### Hamming SECDED ECC\n\n"
        analysis += "**Characteristics:**\n"
        analysis += "- **Error Detection:** Double-bit error detection\n"
        analysis += "- **Error Correction:** Single-bit error correction\n"
        analysis += "- **Redundancy:** 4 bits per 8-bit data (50% overhead)\n"
        analysis += "- **Hardware Cost:** Medium (16+21 = 37 cells)\n"
        analysis += "- **Latency:** Single cycle\n"
        analysis += "- **Power Consumption:** Moderate\n\n"
        analysis += "**Use Cases:**\n"
        analysis += "- Server memory (ECC RAM)\n"
        analysis += "- Critical systems requiring error correction\n"
        analysis += "- High-reliability applications\n"
        analysis += "- Storage systems\n\n"
        
        # Future ECC Types (placeholder)
        analysis += "### Advanced ECC Types (Future Implementation)\n\n"
        analysis += "**BCH (Bose-Chaudhuri-Hocquenghem) ECC:**\n"
        analysis += "- **Error Correction:** Multi-bit error correction\n"
        analysis += "- **Redundancy:** Configurable (typically 20-30%)\n"
        analysis += "- **Use Cases:** Flash memory, SSDs, communication systems\n\n"
        
        analysis += "**Reed-Solomon ECC:**\n"
        analysis += "- **Error Correction:** Burst error correction\n"
        analysis += "- **Redundancy:** Configurable (typically 10-50%)\n"
        analysis += "- **Use Cases:** CDs, DVDs, QR codes, deep space communication\n\n"
        
        return analysis
    
    def generate_verification_results(self) -> str:
        """Generate detailed verification results section."""
        verilator_results = self.get_verilator_results()
        
        verification = "## Hardware Verification Results\n\n"
        
        if not verilator_results:
            verification += "*No hardware verification data available. Verilator not available or no testbenches run.*\n\n"
            return verification
        
        verification += "### Testbench Summary\n\n"
        verification += "| Testbench | Overall Status | Test Cases | Notes |\n"
        verification += "|-----------|----------------|------------|-------|\n"
        
        for tb_name, results in verilator_results.items():
            status = results["status"]
            test_cases = results.get("test_cases", {})
            
            # Count test cases
            test_case_summary = []
            if test_cases:
                for test_name, test_status in test_cases.items():
                    test_case_summary.append(f"{test_name}: {test_status}")
            
            test_case_str = ", ".join(test_case_summary) if test_case_summary else "No test cases"
            
            notes = "Functional verification completed" if status == "PASS" else "Verification failed"
            verification += f"| {tb_name} | {status} | {test_case_str} | {notes} |\n"
        
        # Add detailed simulation output only if available
        if any(results.get("output") for results in verilator_results.values()):
            verification += "\n### Detailed Simulation Output\n\n"
            
            for tb_name, results in verilator_results.items():
                if results.get("output"):
                    verification += f"#### {tb_name}\n\n"
                    verification += "```\n"
                    verification += results["output"]
                    verification += "\n```\n\n"
        
        return verification
    
    def generate_recommendations(self) -> str:
        """Generate recommendations based on analysis results."""
        recommendations = "## Recommendations\n\n"
        
        if not self.analysis_results:
            recommendations += "*No benchmark data available for generating recommendations.*\n\n"
            return recommendations
        
        scenario_recs = self.get_scenario_recommendations()
        all_recs = self.get_recommendations()
        
        if scenario_recs:
            recommendations += "### Best ECC for Different Scenarios:\n\n"
            
            scenario_descriptions = {
                'high_reliability': 'High Reliability Systems',
                'high_efficiency': 'High Efficiency Applications',
                'high_speed': 'High Speed Applications',
                'single_bit_errors': 'Single Bit Error Correction',
                'burst_errors': 'Burst Error Handling',
                'random_errors': 'Random Error Conditions'
            }
            
            for scenario, ecc_type in scenario_recs.items():
                desc = scenario_descriptions.get(scenario, scenario.replace('_', ' ').title())
                recommendations += f"**{desc}:** {ecc_type}\n"
            
            recommendations += "\n"
        
        if all_recs:
            recommendations += "### Detailed Recommendations:\n\n"
            
            for i, rec in enumerate(all_recs[:8], 1):  # Limit to top 8 recommendations
                recommendations += f"{i}. {rec}\n"
            
            recommendations += "\n"
        
        return recommendations
    
    def generate_report(self) -> str:
        """Generate the complete ECC analysis report."""
        # Load data
        benchmark_loaded = self.load_benchmark_data()
        hardware_loaded = self.load_hardware_data()
        
        # Get data
        synthesis_data = self.get_synthesis_data()
        testbench_data = self.get_testbench_data()
        
        # Determine analysis scope
        if benchmark_loaded and self.analysis_results:
            ecc_types = list(self.get_benchmark_summary().keys())
            analysis_scope = f"Comprehensive analysis of {len(ecc_types)} ECC types: {', '.join(ecc_types)}"
        else:
            analysis_scope = "Limited analysis - benchmark data not available"
        
        report = f"""# ECC (Error Correction Code) Analysis Report

**Generated:** {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}  
**Framework Version:** 3.0  
**Analysis Scope:** {analysis_scope}

## Executive Summary

This report provides a comprehensive analysis of different Error Correction Code (ECC) implementations, comparing their performance characteristics, hardware costs, and suitability for various applications. The analysis is based on extensive benchmarking across multiple ECC types, word lengths, and error patterns.

{self.generate_performance_charts()}

{self.generate_performance_comparison_table()}

{self.generate_hardware_comparison_table()}

{self.generate_verification_results()}

{self.generate_ecc_analysis()}

## Key Findings

"""
        
        if benchmark_loaded and self.analysis_results:
            rankings = self.get_performance_rankings()
            if rankings:
                best_ecc = min(rankings, key=rankings.get)
                report += f"1. **Overall Best Performer:** {best_ecc} ranks highest in composite performance score.\n\n"
            
            summary = self.get_benchmark_summary()
            if summary:
                success_rates = [metrics['avg_success_rate'] for metrics in summary.values()]
                best_success = max(success_rates)
                worst_success = min(success_rates)
                report += f"2. **Performance Range:** Success rates range from {worst_success:.1f}% to {best_success:.1f}% across all ECC types.\n\n"
                
                code_rates = [metrics['avg_code_rate'] for metrics in summary.values()]
                best_efficiency = max(code_rates)
                worst_efficiency = min(code_rates)
                report += f"3. **Efficiency Range:** Code rates range from {worst_efficiency:.3f} to {best_efficiency:.3f} across all ECC types.\n\n"
        else:
            report += "1. **Limited Analysis:** Benchmark data not available for comprehensive analysis.\n\n"
            report += "2. **Recommendation:** Run benchmark suite to generate detailed performance metrics.\n\n"
        
        if synthesis_data:
            report += "4. **Hardware Implementation:** Synthesis results available for hardware cost analysis.\n\n"
        else:
            report += "4. **Hardware Implementation:** No synthesis data available. Hardware verification tools may not be installed.\n\n"
        
        if testbench_data:
            report += "5. **Functional Verification:** Testbench results available for functional validation.\n\n"
        else:
            report += "5. **Functional Verification:** No testbench data available. Verilator may not be installed or testbenches not run.\n\n"

        report += f"{self.generate_recommendations()}"

        report += """## Methodology

- **Benchmarking:** Comprehensive testing across multiple ECC types, word lengths, and error patterns
- **Analysis:** Statistical analysis and performance ranking of ECC schemes
- **Synthesis:** Yosys synthesis targeting generic technology library (when available)
- **Validation:** Verilator-based functional verification (when available)
- **Data Processing:** Automated analysis and visualization of results

## Future Work

- **Extended Benchmarking:** Additional ECC types and error patterns
- **Hardware Optimization:** Synthesis optimization techniques
- **Power Analysis:** Detailed power consumption measurements
- **Timing Analysis:** Critical path and performance analysis
- **Real-world Validation:** Testing with actual hardware platforms

## Conclusion

The choice of ECC depends on the specific requirements of the target application. This framework provides comprehensive benchmarking and analysis capabilities to help make informed decisions about ECC selection.

The enhanced analysis demonstrates the importance of considering multiple factors including performance, efficiency, and hardware cost when selecting ECC schemes for specific applications.

---
*Report generated by Enhanced ECC Analysis Framework v3.0*
"""
        
        return report
    
    def save_report(self, filename: str = "ecc_analysis_report.md") -> None:
        """Save the report to a Markdown file."""
        report_content = self.generate_report()
        report_path = self.results_dir / filename
        
        with open(report_path, 'w') as f:
            f.write(report_content)
        
        print(f"Enhanced ECC analysis report saved to: {report_path}")
        
        # List generated files
        if self.results_dir.exists():
            chart_files = list(self.results_dir.glob("*.png"))
            if chart_files:
                print("Generated visualization files:")
                for chart_file in chart_files:
                    print(f"  - {chart_file.name}")

def main():
    """Generate and save the enhanced ECC analysis report."""
    print("Enhanced ECC Analysis Framework v3.0")
    print("====================================")
    
    generator = ECCReportGenerator()
    generator.save_report()
    
    print("\nReport generation complete!")

if __name__ == "__main__":
    main()