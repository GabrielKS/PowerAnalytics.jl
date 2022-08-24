(results_uc, results_ed) = run_test_sim(TEST_RESULT_DIR)
problem_results = run_test_prob()

@testset "test filter results" begin
    gen = PA.get_generation_data(results_uc, curtailment = false)
    @test length(gen.data) == 7
    @test length(gen.time) == 48

    gen = PA.get_generation_data(
        results_uc,
        variable_keys = [
            PowerSimulations.VariableKey{ActivePowerVariable, ThermalStandard}(""),
            PowerSimulations.VariableKey{ActivePowerVariable, RenewableDispatch}(""),
        ],
        parameter_keys = [
            PowerSimulations.ParameterKey{ActivePowerTimeSeriesParameter, RenewableDispatch}(
                "",
            ),
        ],
        initial_time = Dates.DateTime("2020-01-02T02:00:00"),
        len = 3,
    )
    @test length(gen.data) == 3
    @test length(gen.time) == 3

    load = PA.get_load_data(results_ed)
    @test length(load.data) == 1
    @test length(load.time) == 48
    @test !any(Matrix(PA.no_datetime(load.data[:Load])) .< 0.0)

    load = PA.get_load_data(
        results_ed,
        parameter_keys = [
            PowerSimulations.ParameterKey{ActivePowerTimeSeriesParameter, PowerLoad}(""),
        ],
        initial_time = Dates.DateTime("2020-01-02T02:00:00"),
        len = 3,
    )
    @test length(load.data) == 1
    @test length(load.time) == 3
    @test !any(Matrix(PA.no_datetime(load.data[:Load])) .< 0.0)

    srv = PA.get_service_data(results_ed)
    @test length(srv.data) == 0

    srv = PA.get_service_data(results_uc)
    @test length(srv.data) == 1

    srv = PA.get_service_data(
        results_uc,
        variable_keys = [
            PowerSimulations.VariableKey{
                ActivePowerReserveVariable,
                VariableReserve{ReserveUp},
            }(
                "REG1",
            ),
        ],
        initial_time = Dates.DateTime("2020-01-02T02:00:00"),
        len = 5,
    )
    @test length(srv.data) == 1
    @test length(srv.time) == 5
end

@testset "test curtailment calculations" begin
    curtailment_params = PA._curtailment_parameters(
        PA.get_generation_parameter_keys(results_uc),
        PA.get_generation_variable_keys(results_uc),
    )
    @test length(curtailment_params) == 1

    curtailment_params = PA._curtailment_parameters(
        PA.get_generation_parameter_keys(problem_results),
        PA.get_generation_variable_keys(problem_results),
    )
    @test length(curtailment_params) == 1
end

@testset "test data aggregation" begin
    gen = PA.get_generation_data(results_uc)

    cat = PA.make_fuel_dictionary(results_uc.system)
    @test isempty(
        symdiff(
            keys(cat),
            ["Coal", "Wind", "Hydropower", "NG-CC", "NG-CT", "Storage", "PV", "Load"],
        ),
    )

    fuel = categorize_data(gen.data, cat)
    @test length(fuel) == 8

    fuel_agg = PA.combine_categories(fuel)
    @test size(fuel_agg) == (48, 8)
end
