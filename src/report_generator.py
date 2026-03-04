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

# Import ECC classes for parameter extraction
from parity_ecc import ParityECC
from hamming_secded_ecc import HammingSECDEDECC
from bch_ecc import BCHECC
from reed_solomon_ecc import ReedSolomonECC
from crc_ecc import CRCECC
from golay_ecc import GolayECC
from repetition_ecc import RepetitionECC
from ldpc_ecc import LDPCECC
from turbo_ecc import TurboECC
from convolutional_ecc import ConvolutionalECC
from polar_ecc import PolarECC
from extended_hamming_ecc import ExtendedHammingECC
from product_code_ecc import ProductCodeECC
from concatenated_ecc import ConcatenatedECC
from reed_muller_ecc import ReedMullerECC
from fire_code_ecc import FireCodeECC
from spatially_coupled_ldpc_ecc import SpatiallyCoupledLDPCECC
from non_binary_ldpc_ecc import NonBinaryLDPCECC
from raptor_code_ecc import RaptorCodeECC
from composite_ecc import CompositeECC
from system_ecc import SystemECC
from adaptive_ecc import AdaptiveECC
from three_d_memory_ecc import ThreeDMemoryECC
from primary_secondary_ecc import PrimarySecondaryECC
from cyclic_ecc import CyclicECC
from burst_error_ecc import BurstErrorECC

# Mapping from module name (snake_case) to ECC Class
MODULE_TO_CLASS = {
    'parity_ecc': ParityECC,
    'hamming_secded_ecc': HammingSECDEDECC,
    'bch_ecc': BCHECC,
    'reed_solomon_ecc': ReedSolomonECC,
    'crc_ecc': CRCECC,
    'golay_ecc': GolayECC,
    'repetition_ecc': RepetitionECC,
    'ldpc_ecc': LDPCECC,
    'turbo_ecc': TurboECC,
    'convolutional_ecc': ConvolutionalECC,
    'polar_ecc': PolarECC,
    'extended_hamming_ecc': ExtendedHammingECC,
    'product_code_ecc': ProductCodeECC,
    'concatenated_ecc': ConcatenatedECC,
    'reed_muller_ecc': ReedMullerECC,
    'fire_code_ecc': FireCodeECC,
    'spatially_coupled_ldpc_ecc': SpatiallyCoupledLDPCECC,
    'non_binary_ldpc_ecc': NonBinaryLDPCECC,
    'raptor_code_ecc': RaptorCodeECC,
    'composite_ecc': CompositeECC,
    'system_ecc': SystemECC,
    'adaptive_ecc': AdaptiveECC,
    'three_d_memory_ecc': ThreeDMemoryECC,
    'primary_secondary_ecc': PrimarySecondaryECC,
    'cyclic_ecc': CyclicECC,
    'burst_error_ecc': BurstErrorECC
}

# Mapping from class name (PascalCase) to module name (snake_case)
CLASS_TO_MODULE = {cls.__name__: mod for mod, cls in MODULE_TO_CLASS.items()}

class ECCReportGenerator:
    """Generate comprehensive ECC analysis reports based on benchmark results and hardware verification."""
    
    def __init__(self, results_dir: str = "results", use_cache: bool = True):
        self.results_dir = Path(results_dir)
        self.use_cache = use_cache
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
                print("No benchmark results found. Skipping benchmarks for report generation.")
                return False
            
            if self.benchmark_results:
                # Run analysis
                # print("DEBUG: Skipping detailed analysis to speed up report generation.")
                analyzer = ECCAnalyzer(self.benchmark_results)
                self.analysis_results = analyzer.run_complete_analysis(use_cache=self.use_cache)
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
                print("No hardware verification results found. Skipping verification for report generation.")
                return False
            
            return self.hardware_results is not None
            
        except Exception as e:
            print(f"Error loading hardware data: {e}")
            return False

    def get_ecc_params(self, module_name: str, width: int) -> tuple:
        """
        Get ECC parameters (n, k, rate) for a given module and width.
        Returns (n, k, rate) or ("N/A", "N/A", "N/A") if not available.
        Each ECC class has a distinct constructor signature, so we route
        them correctly to pick up width-dependent N and K.
        """
        if module_name not in MODULE_TO_CLASS:
            return "N/A", "N/A", "N/A"
        
        try:
            ecc_class = MODULE_TO_CLASS[module_name]

            # --- Per-module explicit instantiation via data_length=width ---
            # This ensures every class sees the intended data word size and sets
            # its internal n/k accordingly, rather than falling into defaults.
            if module_name == 'repetition_ecc':
                ecc = ecc_class(repetition_factor=3, data_length=width)
            elif module_name in ('reed_solomon_ecc', 'bch_ecc', 'crc_ecc', 'polar_ecc'):
                # These classes all accept data_length as a keyword argument
                # and correctly derive (n, k) from it
                ecc = ecc_class(data_length=width)
            else:
                ecc = ecc_class(width)

            # --- Extract N and K ---
            # Polar uses N_width / k_width as the canonical attrs
            if module_name == 'polar_ecc':
                n = getattr(ecc, 'N_width', getattr(ecc, 'n', "N/A"))
                k = getattr(ecc, 'k_width', getattr(ecc, 'k', "N/A"))
            else:
                n = getattr(ecc, 'n_bits', getattr(ecc, 'n', getattr(ecc, 'N', "N/A")))
                k = getattr(ecc, 'k_bits', getattr(ecc, 'k', getattr(ecc, 'K',
                    getattr(ecc, 'data_length', getattr(ecc, 'word_length', "N/A")))))

            # Calculate rate
            if isinstance(n, (int, float)) and isinstance(k, (int, float)) and n > 0:
                rate = k / n
            else:
                rate = 0.0

            return n, k, rate
        except Exception as e:
            print(f"Warning: Could not get params for {module_name} w{width}: {e}")
            return "N/A", "N/A", "N/A"
    
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
            charts_section += "*Performance trends showing how ECC performance varies with word length (Top 5 performers highlighted).*\n\n"
            
        return charts_section
    
        return ""
    
    def generate_efficiency_latency_chart_section(self) -> str:
        """Generate section for efficiency vs latency trade-off chart."""
        chart_path = self.results_dir / "ecc_efficiency_latency_tradeoff.png"
        if chart_path.exists():
            return f"![ECC Efficiency vs Latency Trade-off](ecc_efficiency_latency_tradeoff.png)\n\n*Trade-off between Code Rate (Efficiency) and Total Latency (Speed). Top-left is better (High Efficiency, Low Latency).*\n\n"
        return ""

    def generate_performance_comparison_chart_section(self) -> str:
        """Generate section for performance comparison chart."""
        chart_path = self.results_dir / "ecc_performance_comparison.png"
        if chart_path.exists():
            return f"![ECC Performance Comparison](ecc_performance_comparison.png)\n\n*Detailed comparison of success, correction, and detection rates across all ECC types.*\n\n"
        return ""

    def _optimal_xtick_fontsize(
        self,
        ax,
        fig,
        min_size: int = 10,
        max_size: int = 30,
        allowed_overlap_px: float = 8.0
    ) -> int:
        """Set the largest x-tick font size that avoids overlap on current canvas."""
        ticklabels = [lbl for lbl in ax.get_xticklabels() if lbl.get_text()]
        if not ticklabels:
            return min_size

        for size in range(max_size, min_size - 1, -1):
            for lbl in ticklabels:
                lbl.set_fontsize(size)
                lbl.set_fontweight('bold')
                lbl.set_fontfamily('serif')

            fig.canvas.draw()
            renderer = fig.canvas.get_renderer()
            bboxes = [lbl.get_window_extent(renderer=renderer) for lbl in ticklabels]

            overlap = any(bboxes[i].x1 > (bboxes[i + 1].x0 + allowed_overlap_px) for i in range(len(bboxes) - 1))
            if not overlap:
                return size

        for lbl in ticklabels:
            lbl.set_fontsize(min_size)
            lbl.set_fontweight('bold')
            lbl.set_fontfamily('serif')
        fig.canvas.draw()
        return min_size

    def generate_radar_chart(self) -> str:
        """Generate a radar chart comparing all ECC types across key metrics."""
        if not self.analysis_results:
            return ""
            
        summary = self.get_benchmark_summary()
        if not summary:
            return ""
            
        try:
            # Metrics to plot
            metrics = ['Reliability', 'Efficiency', 'Encode Speed', 'Decode Speed', 'Hardware Ease']
            num_vars = len(metrics)
            
            # Prepare data
            ecc_types = list(summary.keys())
            
            # Extract raw values
            raw_data = {
                'Reliability': [summary[ecc]['avg_success_rate'] for ecc in ecc_types],
                'Efficiency': [summary[ecc]['avg_code_rate'] for ecc in ecc_types],
                'Encode Speed': [summary[ecc]['avg_encode_time_ms'] for ecc in ecc_types],
                'Decode Speed': [summary[ecc]['avg_decode_time_ms'] for ecc in ecc_types],
                'Hardware Ease': [summary[ecc]['avg_overhead_ratio'] for ecc in ecc_types]
            }
            
            # Normalize data (0 to 1, where 1 is best)
            plot_data = []
            for ecc_idx in range(len(ecc_types)):
                ecc_values = []
                
                # Reliability: higher is better (already 0-1)
                rel = raw_data['Reliability'][ecc_idx]
                ecc_values.append(rel)
                
                # Efficiency: higher is better (already 0-1)
                eff = raw_data['Efficiency'][ecc_idx]
                ecc_values.append(eff)
                
                # Encode Speed: lower is better. Invert and normalize.
                enc_times = raw_data['Encode Speed']
                min_enc, max_enc = min(enc_times), max(enc_times)
                enc = raw_data['Encode Speed'][ecc_idx]
                # Avoid division by zero
                normalized_enc = 1.0 - ((enc - min_enc) / (max_enc - min_enc)) if max_enc > min_enc else 1.0
                ecc_values.append(normalized_enc)
                
                # Decode Speed: lower is better. Invert and normalize.
                dec_times = raw_data['Decode Speed']
                min_dec, max_dec = min(dec_times), max(dec_times)
                dec = raw_data['Decode Speed'][ecc_idx]
                normalized_dec = 1.0 - ((dec - min_dec) / (max_dec - min_dec)) if max_dec > min_dec else 1.0
                ecc_values.append(normalized_dec)
                
                # Hardware Ease (Overhead): lower is better. Invert and normalize.
                overheads = raw_data['Hardware Ease']
                min_ovh, max_ovh = min(overheads), max(overheads)
                ovh = raw_data['Hardware Ease'][ecc_idx]
                normalized_ovh = 1.0 - ((ovh - min_ovh) / (max_ovh - min_ovh)) if max_ovh > min_ovh else 1.0
                ecc_values.append(normalized_ovh)
                
                plot_data.append(ecc_values)

            # Setup plot style
            plt.rcParams.update({
                'font.family': 'serif',
                'font.size': 16,
                'axes.labelsize': 16,
                'axes.titlesize': 18,
                'figure.titlesize': 20,
            })
            
            # Compute angle for each axis
            angles = np.linspace(0, 2 * np.pi, num_vars, endpoint=False).tolist()
            # Close the loop
            angles += angles[:1]
            metrics_labels = metrics + [metrics[0]]
            
            fig, ax = plt.subplots(figsize=(14, 14), subplot_kw=dict(polar=True))
            
            # Draw one axe per variable and add labels
            plt.xticks(angles[:-1], metrics, color='black', size=24, fontweight='bold')
            
            # Draw ylabels
            ax.set_rlabel_position(30)
            plt.yticks([0.2, 0.4, 0.6, 0.8], ["0.2", "0.4", "0.6", "0.8"], color="black", size=24, fontweight='bold')
            plt.ylim(0, 1)
            
            # Style the grid lines separating the concentric circles
            ax.grid(color='grey', linestyle='--', linewidth=1.5, alpha=0.5)
            
            # Plot each ECC type line
            # Too many lines will be messy. We will heavily fade non-top 3.
            # Use tab20c/tab20b to get more distinct colors
            cmap = plt.get_cmap('tab20')
            colors = [cmap(i) for i in np.linspace(0, 1, 20)]
            # If more than 20, cycle back with a slight variation or just reuse
            if len(ecc_types) > 20:
                cmap2 = plt.get_cmap('tab20b')
                more_colors = [cmap2(i) for i in np.linspace(0, 1, len(ecc_types) - 20)]
                colors.extend(more_colors)
            
            # Determine Top 3 by unweighted average of normalized scores
            overall_scores = [sum(data)/len(data) for data in plot_data]
            top_3_indices = np.argsort(overall_scores)[-3:]
            
            # Define linestyles and markers to help differentiate lines
            linestyles = ['solid', 'dashed', 'dashdot', 'dotted']
            markers = ['o', 's', '^', 'D', 'v', '<', '>', 'p', '*', 'h']
            
            for i, data in enumerate(plot_data):
                data += data[:1] # close the loop
                
                is_top_3 = i in top_3_indices
                linewidth = 2.0 if is_top_3 else 1.2
                alpha = 0.95 if is_top_3 else 0.45 # Moderately fade non-top 3
                zorder = 10 if is_top_3 else 1
                linestyle = linestyles[i % len(linestyles)]
                marker = markers[i % len(markers)]
                
                ax.plot(
                    angles, data, 
                    color=colors[i], 
                    linewidth=linewidth, 
                    linestyle=linestyle, 
                    marker=marker if is_top_3 else None, # Only add markers to top 3 to reduce clutter
                    markersize=8,
                    label=ecc_types[i], 
                    alpha=alpha, 
                    zorder=zorder
                )
                
                if is_top_3:
                    ax.fill(angles, data, color=colors[i], alpha=0.15, zorder=zorder)

            # Add legend (single column, moved further right to avoid blocking the graph)
            leg = plt.legend(loc='center left', bbox_to_anchor=(1.15, 0.5), fontsize=20, ncol=1)
            # Ensure legend lines are opaque regardless of plot alpha
            for legobj in leg.legend_handles:
                legobj.set_alpha(1.0)
                legobj.set_linewidth(2.0)
            
            # Use fig.suptitle to position it over the entire figure rather than just the polar plot
            fig.suptitle('Multi-Dimensional Performance Comparison\n(Normalized: 1.0 = Best)', fontsize=36, fontweight='bold', x=0.65, y=1.05)
            
            # Save chart
            chart_path = self.results_dir / "ecc_performance_radar.png"
            plt.savefig(chart_path, dpi=300, bbox_inches='tight')
            
            pdf_path = self.results_dir / "ecc_performance_radar.pdf"
            plt.savefig(pdf_path, dpi=300, bbox_inches='tight')
            
            plt.close()
            
            md_section = f"![ECC Performance Radar](ecc_performance_radar.png)\n\n"
            md_section += "*Radar chart comparing all ECC types across normalized metrics. "
            md_section += "Top 3 ECC types overall are highlighted with thicker lines. "
            md_section += "Scale is 0-1, where 1 indicates the best performance in that metric "
            md_section += "(e.g., lowest latency, lowest overhead, highest reliability).*\n\n"
            md_section += "**Normalized Metrics Definition (1.0 = Best):**\n"
            md_section += "- **Reliability**: Average Success Rate (already 0-1).\n"
            md_section += "- **Efficiency**: Average Code Rate (already 0-1).\n"
            md_section += "- **Encode Speed**: Normalized Average Encode Time (inverted so lower time = closer to 1).\n"
            md_section += "- **Decode Speed**: Normalized Average Decode Time (inverted so lower time = closer to 1).\n"
            md_section += "- **Hardware Ease**: Normalized Average Overhead Ratio (inverted so lower overhead = closer to 1).\n\n"
            
            return md_section
            
        except Exception as e:
            print(f"Error generating radar chart: {e}")
            return ""

    def generate_performance_comparison_table(self) -> str:
        """Generate a performance comparison table from benchmark results."""
        if not self.analysis_results:
            return "## Performance Comparison\n\n*No benchmark data available for performance comparison.*\n\n"
        
        summary = self.get_benchmark_summary()
        if not summary:
            return "## Performance Comparison\n\n*No benchmark summary available.*\n\n"
        
        table = "## Performance Comparison\n\n"
        table += self.generate_radar_chart()
        table += self.generate_performance_comparison_chart_section()
        table += self.generate_efficiency_latency_chart_section()
        table += "> **Note:** The values below are **averaged** across all simulated configuration pairs (Word Lengths: 4, 8, 16, 32, 64, 128 and Error Patterns: Single, Double, Burst, Random).\n"
        table += "> **Metric Definitions:**\n"
        table += "> - **Success Rate**: % of trials where output matches original data (Corrected + Detected).\n"
        table += "> - **Correction Rate**: % of trials where errors were successfully fixed.\n"
        table += "> - **Detection Rate**: % of trials where errors were detected but **NOT** corrected (i.e. uncorrectable errors caught by the ECC).\n\n"
        table += "| ECC Type | Success Rate (%) | Correction Rate (%) | Detection Rate (%) | Code Rate | Overhead Ratio | Encode Time (ms) | Decode Time (ms) |\n"
        table += "|----------|------------------|-------------------|-------------------|-----------|----------------|------------------|------------------|\n"
        
        # Sort by success rate
        sorted_summary = sorted(summary.items(), key=lambda x: x[1]['avg_success_rate'], reverse=True)
        
        for ecc_type, metrics in sorted_summary:
            table += f"| {ecc_type} | {metrics['avg_success_rate']*100:.2f} | {metrics['avg_correction_rate']*100:.2f} | {metrics['avg_detection_rate']*100:.2f} | {metrics['avg_code_rate']:.3f} | {metrics['avg_overhead_ratio']:.3f} | {metrics['avg_encode_time_ms']:.6f} | {metrics['avg_decode_time_ms']:.6f} |\n"
        
        return table
    
    def generate_detailed_performance_tables_by_width(self) -> str:
        """Generate detailed performance tables for each data width."""
        if not self.benchmark_results:
            return ""
            
        # Convert to DataFrame for easy filtering (reusing logic from ECCAnalyzer)
        data = []
        for result in self.benchmark_results:
            data.append({
                'ecc_type': result.ecc_type,
                'word_length': result.word_length,
                'trials': result.trials,
                'correctable': result.correctable_errors,
                'detected': result.detected_errors,
                'code_rate': result.code_rate,
                'overhead_ratio': result.overhead_ratio,
                'total_time': result.total_time_avg,
                # Recalculate rates
                'success_rate': (result.correctable_errors + result.detected_errors) / result.trials if result.trials > 0 else 0.0,
                'correction_rate': result.correctable_errors / result.trials if result.trials > 0 else 0.0,
                'detection_rate': result.detected_errors / result.trials if result.trials > 0 else 0.0
            })
            
        df = pd.DataFrame(data)
        widths = sorted(df['word_length'].unique())
        
        tables = ""
        
        for width in widths:
            tables += f"\n### Performance Metrics for {width}-bit Data Width\n\n"
            tables += "| ECC Type | Code Params (N, K) | Success Rate (%) | Correction Rate (%) | Detection Rate (%) | Code Rate | Overhead Ratio | Total Time (ms) |\n"
            tables += "|----------|-------------------|------------------|-------------------|-------------------|-----------|----------------|-----------------|\n"
            
            width_df = df[df['word_length'] == width]
            
            # Calculate summary for this width
            width_results = []
            for ecc_type in width_df['ecc_type'].unique():
                ecc_data = width_df[width_df['ecc_type'] == ecc_type]
                width_results.append({
                    'ecc_type': ecc_type,
                    'avg_success_rate': ecc_data['success_rate'].mean(),
                    'avg_correction_rate': ecc_data['correction_rate'].mean(),
                    'avg_detection_rate': ecc_data['detection_rate'].mean(),
                    'avg_code_rate': ecc_data['code_rate'].mean(),
                    'avg_overhead_ratio': ecc_data['overhead_ratio'].mean(),
                    'avg_total_time_ms': ecc_data['total_time'].mean() * 1000
                })
            
            # Sort by success rate
            width_results.sort(key=lambda x: x['avg_success_rate'], reverse=True)
            
            for m in width_results:
                 # Get (N, K) params
                 module_name = CLASS_TO_MODULE.get(m['ecc_type'], "N/A")
                 n, k, _ = self.get_ecc_params(module_name, width)
                 params_str = f"({n}, {k})" if n != "N/A" else "N/A"
                 
                 tables += f"| {m['ecc_type']} | {params_str} | {m['avg_success_rate']*100:.2f} | {m['avg_correction_rate']*100:.2f} | {m['avg_detection_rate']*100:.2f} | {m['avg_code_rate']:.3f} | {m['avg_overhead_ratio']:.3f} | {m['avg_total_time_ms']:.6f} |\n"
        
        return tables
    
    def load_synthesis_multi_width_data(self) -> Dict[str, Dict[str, int]]:
        """Load multi-width synthesis results from synthesis_results.json."""
        synthesis_file = self.results_dir / "synthesis_results.json"
        if synthesis_file.exists():
            try:
                with open(synthesis_file, 'r') as f:
                    return json.load(f)
            except Exception as e:
                print(f"Error loading synthesis_results.json: {e}")
        return {}

    def generate_hardware_cost_chart(self) -> str:
        """
        Generate hardware cost chart (Area vs Module) for 64-bit data width.
        Returns markdown string for the report.
        """
        data = self.load_synthesis_multi_width_data()
        if not data:
            return ""

        # Extract 64-bit data
        cost_data = {}
        for module, widths in data.items():
            # Check for 64-bit data (keys are strings in JSON)
            if "64" in widths and widths["64"] is not None:
                cost_data[module] = widths["64"]
            # Fallback to int key check just in case
            elif 64 in widths and widths[64] is not None:
                cost_data[module] = widths[64]
        
        if not cost_data:
            return ""

        try:
            # Sort by cell count
            sorted_items = sorted(cost_data.items(), key=lambda x: x[1])
            modules = [item[0] for item in sorted_items]
            cells = [item[1] for item in sorted_items]
            
            # Setup plot style matching previous verifier implementation
            plt.rcParams.update({
                'font.family': 'serif',
                'font.size': 12,
                'font.weight': 'bold',
                'axes.labelweight': 'bold',
                'axes.titleweight': 'bold',
                'axes.labelsize': 12,
                'axes.titlesize': 14,
                'figure.titlesize': 16,
                'axes.grid': True,
                'grid.alpha': 0.3,
                'grid.linestyle': '--',
            })
            
            fig_width = 14.0
            fig_height = 8.0
            label_rotation = 68

            fig, ax = plt.subplots(figsize=(fig_width, fig_height))
            x = np.arange(len(modules))
            width = 0.6
            
            bars = ax.bar(x, cells, width, label='Area (Cells)', color='#0000FF', alpha=0.9, edgecolor='black')
            
            ax.set_ylabel('Area (Cells)', fontsize=14, fontweight='bold', fontfamily='serif')
            ax.set_xlabel('ECC Type', fontsize=14, fontweight='bold', fontfamily='serif')
            ax.set_xticks(x)
            ax.set_xticklabels(modules, rotation=label_rotation, ha='right')
            xtick_font = 12
            for lbl in ax.get_xticklabels():
                lbl.set_fontsize(xtick_font)
                lbl.set_fontweight('bold')
                lbl.set_fontfamily('serif')

            ax.set_title('Hardware Cost Comparison: Area (Cells) - 64-bit Data Width', fontsize=max(18, xtick_font + 6), fontweight='bold', fontfamily='serif', pad=20)
            ax.tick_params(axis='y', labelsize=max(11, xtick_font - 1))
            for label in ax.get_yticklabels():
                label.set_fontweight('bold')
                label.set_fontfamily('serif')

            ax.legend(loc='upper left', fontsize=max(11, xtick_font - 1), prop={'family': 'serif', 'weight': 'bold'})
            
            # Add value labels
            for bar, cell_count in zip(bars, cells):
                ax.text(bar.get_x() + bar.get_width() / 2., bar.get_height(),
                    f'{cell_count}', ha='center', va='bottom', fontsize=max(10, xtick_font - 1), fontweight='bold')
            
            fig.tight_layout(rect=[0, 0.08, 1, 1])
            
            chart_path = self.results_dir / "ecc_hardware_cost.png"
            plt.savefig(chart_path, dpi=300, bbox_inches='tight')
            
            pdf_path = self.results_dir / "ecc_hardware_cost.pdf"
            plt.savefig(pdf_path, dpi=300, bbox_inches='tight')
            
            plt.close()
            
            return f"![ECC Hardware Cost Comparison](ecc_hardware_cost.png)\n\n*Relative hardware cost comparison of ECC types (in Yosys internal cells, 64-bit data width).*\n\n"
            
        except Exception as e:
            print(f"Error generating hardware cost chart: {e}")
            return ""

    def generate_hardware_scaling_chart(self) -> str:
        """Generate hardware scaling chart (Area vs Width)."""
        data = self.load_synthesis_multi_width_data()
        if not data:
            return ""
            
        # Filter valid data
        plot_data = {}
        for module, widths in data.items():
            # Check if we have valid data points (ignore modules with all nulls)
            if widths and any(v is not None for v in widths.values()):
                # Convert string keys to ints for sorting
                valid_points = {int(k): v for k, v in widths.items() if v is not None}
                if len(valid_points) >= 2: # Need at least 2 points for a line
                    plot_data[module] = dict(sorted(valid_points.items()))

        if not plot_data:
            return ""

        try:
            plt.figure(figsize=(12, 8))
            
            # Select top modules to avoid clutter (e.g. top 10 most complex or just all if few)
            # For now, plot all found
            markers = ['o', 's', '^', 'D', 'v', '<', '>', 'p', '*', 'h']
            
            for i, (module, points) in enumerate(plot_data.items()):
                x = list(points.keys())
                y = list(points.values())
                marker = markers[i % len(markers)]
                plt.plot(x, y, marker=marker, linewidth=2, label=module, alpha=0.8)

            plt.title('Hardware Area Scaling vs Data Width', fontsize=16, fontweight='bold', fontfamily='serif')
            plt.xlabel('Data Width (bits)', fontsize=14, fontweight='bold', fontfamily='serif')
            plt.ylabel('Area (Cells)', fontsize=14, fontweight='bold', fontfamily='serif')
            plt.grid(True, alpha=0.3, linestyle='--')
            plt.legend(bbox_to_anchor=(1.05, 1), loc='upper left')
            plt.tight_layout()
            
            chart_path = self.results_dir / "ecc_hardware_scaling.png"
            plt.savefig(chart_path, dpi=300, bbox_inches='tight')
            plt.close()
            
            return f"![ECC Hardware Scaling](ecc_hardware_scaling.png)\n\n*Hardware area scaling with increasing data width.*\n\n"
        except Exception as e:
            print(f"Error generating hardware scaling chart: {e}")
            return ""

    def generate_hardware_comparison_table(self) -> str:
        """Generate a hardware cost comparison table from synthesis results."""
        # Try loading multi-width data first
        multi_width_data = self.load_synthesis_multi_width_data()
        synthesis_data = {}
        target_width = "64"
        
        if multi_width_data:
            # Extract data for target width
            for module, width_data in multi_width_data.items():
                if width_data and width_data.get(target_width) is not None:
                    synthesis_data[module] = width_data[target_width]
        
        # Fallback to hardware_verification_results.json if no multi-width data
        if not synthesis_data:
             synthesis_data = self.get_synthesis_data()
        
        if not synthesis_data:
            return "## Hardware Cost Comparison\n\n*No synthesis data available. Hardware verification not completed or tools not available.*\n\n"
        
        table = "## Hardware Cost Comparison\n\n"
        
        # Add hardware cost chart
        table += self.generate_hardware_cost_chart()
            
        # Add scaling chart
        scaling_chart_md = self.generate_hardware_scaling_chart()
        if scaling_chart_md:
            table += scaling_chart_md

        # Retrieve testbench cycle counts
        testbench_data = self.get_testbench_data()

        # Generate table for 32-bit (or available)
        table += f"### Relative Cost and Cycle Counts (Normalized to minimum, 64-bit Data Width)\n\n"
        table += "| Module | Area (Cells) | Relative Cost | Encode Cycles | Decode Cycles |\n"
        table += "|--------|--------------|---------------|---------------|---------------|\n"
        
        if synthesis_data:
            # Filter out 0 or None
            valid_data = {k: v for k, v in synthesis_data.items() if v is not None and v > 0}
            if valid_data:
                min_cost = min(valid_data.values())
                
                # Sort by area
                sorted_data = dict(sorted(valid_data.items(), key=lambda item: item[1]))

                for module, cells in sorted_data.items():
                    relative_cost = (cells / min_cost) if min_cost > 0 else 1
                    
                    tb_data = testbench_data.get(f"{module}_tb", {})
                    enc_cycles = tb_data.get("encode_cycles", "N/A")
                    dec_cycles = tb_data.get("decode_cycles", "N/A")
                    
                    table += f"| {module} | {cells} | {relative_cost:.1f}x | {enc_cycles} | {dec_cycles} |\n"
            else:
                 table += "| No valid synthesis data | - | - | - | - |\n"
        else:
            table += "| No synthesis data available | - | - | - | - |\n"
        
        return table
    
    def generate_ecc_analysis(self) -> str:
        """Generate detailed analysis of each ECC type."""
        analysis = "## Detailed ECC Analysis\n\n"
        
        # Get 64-bit synthesis data for consistency
        multi_width_data = self.load_synthesis_multi_width_data()
        synthesis_data = {}
        target_width = "64"
        if multi_width_data:
            for module, width_data in multi_width_data.items():
                if width_data and width_data.get(target_width) is not None:
                    synthesis_data[module] = width_data[target_width]
        if not synthesis_data:
            synthesis_data = self.get_synthesis_data()
            
        parity_cells = synthesis_data.get("parity_ecc", "N/A")
        hamming_cells = synthesis_data.get("hamming_secded_ecc", "N/A")
        bch_cells = synthesis_data.get("bch_ecc", "N/A")
        rs_cells = synthesis_data.get("reed_solomon_ecc", "N/A")
        
        # Parity ECC Analysis
        analysis += "### Parity Bit ECC\n\n"
        analysis += "**Characteristics:**\n"
        analysis += "- **Error Detection:** Single-bit error detection only\n"
        analysis += "- **Error Correction:** None\n"
        analysis += "- **Redundancy:** 1 bit per data word\n"
        analysis += f"- **Hardware Cost:** Low ({parity_cells} cells at 64-bit)\n"
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
        analysis += "- **Redundancy:** Logarithmic (e.g., 8 bits for 64-bit data)\n"
        analysis += f"- **Hardware Cost:** Medium ({hamming_cells} cells at 64-bit)\n"
        analysis += "- **Latency:** Single cycle\n"
        analysis += "- **Power Consumption:** Moderate\n\n"
        analysis += "**Use Cases:**\n"
        analysis += "- Server memory (ECC RAM)\n"
        analysis += "- Critical systems requiring error correction\n"
        analysis += "- High-reliability applications\n"
        analysis += "- Storage systems\n\n"
        
        # Advanced ECC Types
        analysis += "### Advanced ECC Types\n\n"
        analysis += "**BCH (Bose-Chaudhuri-Hocquenghem) ECC:**\n"
        analysis += "- **Error Correction:** Multi-bit error correction\n"
        analysis += "- **Redundancy:** Configurable (typically 20-30%)\n"
        analysis += f"- **Hardware Cost:** High ({bch_cells} cells at 64-bit)\n"
        analysis += "- **Use Cases:** Flash memory, SSDs, communication systems\n\n"
        
        analysis += "**Reed-Solomon ECC:**\n"
        analysis += "- **Error Correction:** Burst error correction\n"
        analysis += "- **Redundancy:** Configurable (typically 10-50%)\n"
        analysis += f"- **Hardware Cost:** Medium ({rs_cells} cells at 64-bit)\n"
        analysis += "- **Use Cases:** CDs, DVDs, QR codes, deep space communication\n\n"
        
        return analysis
    
    def generate_overall_verification_summary(self) -> str:
        """Generate a high-level verification summary table."""
        total_modules = len(MODULE_TO_CLASS)
        primary_modules = 26 # As defined in Phase 5
        
        # 1. Hardware Results Aggregation
        passed_modules = 0
        failed_modules = 0
        total_test_vectors = 0
        total_tests_passed = 0
        execution_time = 0.0
        hw_widths = set()
        
        if self.hardware_results:
             h = self.hardware_results
             
             # execution_time and average_runtime are direct attributes
             execution_time = getattr(h, 'execution_time', 0.0) if getattr(h, 'execution_time', 0.0) else 0.0
             
             # Aggregate results from testbench_results
             tb_results = getattr(h, 'testbench_results', {})
             if tb_results:
                 # Count unique modules (strip _tb)
                 unique_passed = set()
                 unique_failed = set()
                 
                 for tb_name, res in tb_results.items():
                     mod_name = tb_name.replace('_tb', '')
                     status = getattr(res, 'simulation_status', 'N/A')
                     
                     if status == 'PASS':
                         unique_passed.add(mod_name)
                     elif status == 'FAIL':
                         unique_failed.add(mod_name)
                         
                     # Count test cases and extract widths
                     test_cases = getattr(res, 'test_cases', {})
                     if test_cases:
                         total_test_vectors += len(test_cases)
                         for t_name, t_status in test_cases.items():
                             if t_status == 'PASS':
                                 total_tests_passed += 1
                             
                             # Extract width from test case name (e.g., hardware_verification_w64)
                             if "hardware_verification_w" in t_name:
                                 try:
                                     width = int(t_name.split('w')[-1])
                                     hw_widths.add(width)
                                 except (ValueError, IndexError):
                                     pass
                 
                 passed_modules = len(unique_passed)
                 failed_modules = len(unique_failed)
        
        # 2. Algorithmic Results Aggregation
        algo_total_time = 0.0
        algo_widths = set()
        algo_total_trials = 0
        
        if hasattr(self, 'benchmark_results') and self.benchmark_results:
            for res in self.benchmark_results:
                # Support both object and dict access
                if hasattr(res, 'total_time_avg'):
                    trials = getattr(res, 'trials', 0)
                    time_avg = getattr(res, 'total_time_avg', 0.0)
                    width = getattr(res, 'word_length', 0)
                else:
                    trials = res.get('trials', 0)
                    time_avg = res.get('total_time_avg', 0.0)
                    width = res.get('word_length', 0)
                
                algo_total_time += trials * time_avg
                if width > 0:
                    algo_widths.add(width)
                algo_total_trials += trials

        # Formatting widths as comma-separated strings
        hw_widths_str = ", ".join(map(str, sorted(list(hw_widths)))) if hw_widths else "N/A"
        algo_widths_str = ", ".join(map(str, sorted(list(algo_widths)))) if algo_widths else "N/A"
        
        # Fallback values if data is missing or partial, but try to be accurate
        pass_rate = (passed_modules / primary_modules * 100) if primary_modules > 0 else 0
        test_pass_rate = (total_tests_passed / total_test_vectors * 100) if total_test_vectors > 0 else 0
        avg_runtime = (execution_time / passed_modules) if passed_modules > 0 else 0
        
        summary = "## Overall Verification Summary\n\n"
        summary += "| Metric | Value |\n"
        summary += "|--------|-------|\n"
        summary += f"| Total ECC types analyzed | {primary_modules} |\n"
        summary += f"| Algorithmic Data Widths | {algo_widths_str} bits |\n"
        summary += f"| Algorithmic Total trials | {algo_total_trials} |\n"
        summary += f"| Algorithmic Total runtime (s) | {algo_total_time:.2f} |\n"
        summary += "| | |\n" # Separator
        summary += f"| Hardware Modules Passed | {passed_modules} / {primary_modules} |\n"
        summary += f"| Hardware Verification Pass Rate | {pass_rate:.1f}% |\n"
        summary += f"| Hardware Data Widths | {hw_widths_str} bits |\n"
        summary += f"| Hardware Total test vectors | {total_test_vectors} |\n"
        
        # Split runtimes
        verilator_time = getattr(h, 'verilator_time', 0.0)
        synthesis_time = getattr(h, 'synthesis_time', 0.0)
        
        # If legacy result without split times, assume execution_time is total
        if verilator_time is None: verilator_time = 0.0
        if synthesis_time is None: synthesis_time = execution_time
        
        summary += f"| Hardware Total runtime (s) | {execution_time:.2f} |\n"
        summary += f"| - Verilator (Functional) | {verilator_time:.2f} |\n"
        summary += f"| - Yosys (Synthesis) | {synthesis_time:.2f} |\n"
        summary += f"| Average runtime per module (s) | {avg_runtime:.2f} |\n\n"
        
        return summary

    def generate_verification_results(self) -> str:
        """Generate detailed verification results section."""
        verilator_results = self.get_verilator_results()
        
        verification = "## Hardware Verification Results\n\n"
        
        if self.hardware_results:
            if self.hardware_results.execution_time:
                verification += f"**Total Verification Time:** {self.hardware_results.execution_time:.2f}s\n"
            if self.hardware_results.average_runtime_per_module:
                verification += f"**Average Runtime per Module:** {self.hardware_results.average_runtime_per_module:.4f}s\n\n"
        
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
                'double_bit_errors': 'Double Bit Error Correction',
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

    def generate_width_comparison_sections(self) -> str:
        """Generate comparison sections for each data width."""
        widths = [4, 8, 16, 32, 64, 128]
        sections = "## Comparative Analysis by Data Width\n\n"
        sections += "> **Note on Synthesis Area:** Hardware area values (cell count) are measured by\n"
        sections += "> **Yosys logic synthesis** using technology-independent generic cells, with full\n"
        sections += "> sub-module flattening (`hierarchy + flatten`). Area naturally scales with data width.\n\n"
        
        # Load all data
        synthesis_data = self.load_synthesis_multi_width_data() # {module: {width: area}}
        verilator_results = self.get_verilator_results() # {tb_name: {test_cases: {...}}}
        

        for width in widths:
            sections += f"### Data Width: {width} Bits\n\n"
            sections += f"| ECC Module | Synthesis Area (Cells, Yosys) | Hardware Verification Status |\n"
            sections += f"|------------|-------------------------------|------------------------------|\n"
            
            # We iterate over all known modules defined in the system
            # This ensures even those without hardware results appear in the report
            sorted_modules = sorted(list(MODULE_TO_CLASS.keys()))
            
            # Map tb names to modules for status lookup
            tb_map = {k.replace('_tb', ''): k for k in verilator_results.keys()}
            
            for module in sorted_modules:
                # 1. Code Params
                n, k, rate = self.get_ecc_params(module, width)
                if isinstance(rate, float):
                    rate_str = f"{rate:.3f}"
                else:
                    rate_str = "N/A"
                
                params_str = f"({n}, {k})" if n != "N/A" else "N/A"

                # 2. Hardware Area
                area = "N/A"
                if module in synthesis_data:
                    # width is int, keys might be str
                    w_key = str(width)
                    if w_key in synthesis_data[module]:
                        val = synthesis_data[module][w_key]
                        area = f"{val}" if val is not None else "N/A"
                
                # 3. Verification Status
                status = "N/A"
                tb_name = module + "_tb"
                if tb_name in verilator_results:
                    test_cases = verilator_results[tb_name].get("test_cases", {})
                    # Look for specific test case "hardware_verification_w{width}"
                    target_test = f"hardware_verification_w{width}"
                    if test_cases and target_test in test_cases:
                         status = "PASS" if test_cases[target_test] == "PASS" else "FAIL"
                    else:
                        status = "MISSING"
                
                # Filter rows where data exists - DISABLED to show all 26 types
                # if area != "N/A" or status != "N/A" or params_str != "N/A":
                sections += f"| {module} | {area} | {status} |\n"
            
            sections += "\n"
            
        return sections
    
    def generate_report(self) -> str:
        """Generate the complete ECC analysis report."""
        # Load data
        benchmark_loaded = self.load_benchmark_data()
        hardware_loaded = self.load_hardware_data()
        
        # Generate hardware visualizations if results are available
        # Generate report content
        
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

{self.generate_overall_verification_summary()}

{self.generate_performance_comparison_table()}

{self.generate_detailed_performance_tables_by_width()}

{self.generate_hardware_comparison_table()}

{self.generate_verification_results()}

{self.generate_ecc_analysis()}

{self.generate_width_comparison_sections()}

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
                
                if best_success <= 1.0:
                    best_success *= 100
                    worst_success *= 100
                    
                report += f"2. **Performance Range:** Success rates range from {worst_success:.1f}% to {best_success:.1f}% across all ECC types.\n\n"
                
                code_rates = [metrics['avg_code_rate'] for metrics in summary.values()]
                best_efficiency = max(code_rates)
                worst_efficiency = min(code_rates)
                report += f"3. **Efficiency Range:** Code rates range from {worst_efficiency:.3f} to {best_efficiency:.3f} across all ECC types.\n\n"
        else:
            report += "1. **Limited Analysis:** Benchmark data not available for comprehensive analysis.\n\n"
            report += "2. **Recommendation:** Run benchmark suite to generate detailed performance metrics.\n\n"
        
        # Check secondary source for synthesis data (JSON file)
        multi_width_synthesis = self.load_synthesis_multi_width_data()
        
        if synthesis_data or multi_width_synthesis:
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