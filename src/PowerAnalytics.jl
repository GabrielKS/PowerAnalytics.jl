module PowerAnalytics

export make_fuel_dictionary
export get_generation_data
export get_load_data
export get_service_data
export categorize_data
export no_datetime

export ComponentSelector, SingularComponentSelector, PluralComponentSelector
export make_selector, get_name, get_subselectors
export Metric, TimedMetric, TimelessMetric, ComponentSelectorTimedMetric,
    ComponentTimedMetric,
    SystemTimedMetric, ResultsTimelessMetric, CustomTimedMetric
export DATETIME_COL, META_COL_KEY, SYSTEM_COL, RESULTS_COL, AGG_META_KEY
export is_col_meta, set_col_meta, set_col_meta!, time_df, time_vec, data_cols, data_df,
    data_vec, data_mat, get_description, get_component_agg_fn, get_time_agg_fn,
    with_component_agg_fn, with_time_agg_fn, metric_selector_to_string, get_agg_meta,
    set_agg_meta!
export compute, compute_set, compute_all, hcat_timed, aggregate_time, compose_metrics
export create_problem_results_dict
export parse_generator_mapping
export calc_active_power, calc_production_cost, calc_startup_cost, calc_shutdown_cost,
    calc_discharge_cycles, calc_system_slack_up, calc_load_forecast, calc_active_power_in,
    calc_active_power_out, calc_stored_energy, calc_active_power_forecast, calc_curtailment,
    calc_sum_objective_value, calc_sum_solve_time, calc_sum_bytes_alloc, calc_total_cost,
    make_calc_is_slack_up, calc_is_slack_up, calc_system_load_forecast,
    calc_net_load_forecast, calc_curtailment_frac, calc_load_from_storage,
    calc_system_load_from_storage, calc_integration, calc_capacity_factor
export mean, weighted_mean, unweighted_sum

#I/O Imports
import Dates
import TimeSeries
import Statistics
import Statistics: mean
import DataFrames
import DataFrames: DataFrame, metadata, metadata!, colmetadata, colmetadata!
import YAML
import DataStructures: SortedDict
import PowerSystems
import PowerSystems:
    Component,
    ComponentSelector,
    make_selector, get_name, get_groups,
    get_component, get_components,
    get_available,
    COMPONENT_NAME_DELIMETER

import InfrastructureSystems
import PowerSimulations
import InteractiveUtils

const PSY = PowerSystems
const IS = InfrastructureSystems
const PSI = PowerSimulations

include("definitions.jl")
include("get_data.jl")
include("fuel_results.jl")

include("metrics.jl")
include("input_utils.jl")
include("builtin_component_selectors.jl")
include("builtin_metrics.jl")

# Submodules
using .Selectors

greet() = print("Hello World!")

end # module PowerAnalytics
