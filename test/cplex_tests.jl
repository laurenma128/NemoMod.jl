#=
    NEMO: Next Energy Modeling system for Optimization.
    https://github.com/sei-international/NemoMod.jl

    Copyright © 2019: Stockholm Environment Institute U.S.

	File description: Tests of NemoMod package using CPLEX solver.
=#

try
    using CPLEX
catch e
    @info "Error when initializing CPLEX. Error message: " * sprint(showerror, e) * "."
    @info "Skipping CPLEX tests."
    # Continue
end

# Tests will be skipped if CPLEX package is not installed.
if @isdefined CPLEX
    @info "Testing scenario solution with CPLEX."

    @testset "Solving storage_test with CPLEX" begin
        dbfile = joinpath(@__DIR__, "storage_test.sqlite")
        #dbfile = "c:/temp/storage_test.sqlite"
        chmod(dbfile, 0o777)  # Make dbfile read-write. Necessary because after Julia 1.0, Pkg.add makes all package files read-only

        # Test with default outputs
        NemoMod.calculatescenario(dbfile; jumpmodel = JuMP.Model(CPLEX.Optimizer),
            restrictvars=false, quiet = false)

        db = SQLite.DB(dbfile)

        if !compilation
            testqry = SQLite.DBInterface.execute(db, "select * from vtotaldiscountedcost") |> DataFrame

            @test testqry[1,:y] == "2020"
            @test testqry[2,:y] == "2021"
            @test testqry[3,:y] == "2022"
            @test testqry[4,:y] == "2023"
            @test testqry[5,:y] == "2024"
            @test testqry[6,:y] == "2025"
            @test testqry[7,:y] == "2026"
            @test testqry[8,:y] == "2027"
            @test testqry[9,:y] == "2028"
            @test testqry[10,:y] == "2029"

            @test isapprox(testqry[1,:val], 3845.15703404259; atol=TOL)
            @test isapprox(testqry[2,:val], 146.55227050539; atol=TOL)
            @test isapprox(testqry[3,:val], 139.57362837926; atol=TOL)
            @test isapprox(testqry[4,:val], 132.927266053843; atol=TOL)
            @test isapprox(testqry[5,:val], 126.597396376304; atol=TOL)
            @test isapprox(testqry[6,:val], 120.568948487497; atol=TOL)
            @test isapprox(testqry[7,:val], 114.827569988092; atol=TOL)
            @test isapprox(testqry[8,:val], 109.35959046485; atol=TOL)
            @test isapprox(testqry[9,:val], 104.151990918904; atol=TOL)
            @test isapprox(testqry[10,:val], 99.1923723037184; atol=TOL)
        end

        # Test with optional outputs
        NemoMod.calculatescenario(dbfile; jumpmodel = JuMP.Model(CPLEX.Optimizer),
            varstosave =
                "vrateofproductionbytechnologybymode, vrateofusebytechnologybymode, vrateofdemand, vproductionbytechnology, vtotaltechnologyannualactivity, "
                * "vtotaltechnologymodelperiodactivity, vusebytechnology, vmodelperiodcostbyregion, vannualtechnologyemissionpenaltybyemission, "
                * "vtotaldiscountedcost",
            restrictvars=false, quiet = false)

        if !compilation
            testqry = SQLite.DBInterface.execute(db, "select * from vtotaldiscountedcost") |> DataFrame

            @test testqry[1,:y] == "2020"
            @test testqry[2,:y] == "2021"
            @test testqry[3,:y] == "2022"
            @test testqry[4,:y] == "2023"
            @test testqry[5,:y] == "2024"
            @test testqry[6,:y] == "2025"
            @test testqry[7,:y] == "2026"
            @test testqry[8,:y] == "2027"
            @test testqry[9,:y] == "2028"
            @test testqry[10,:y] == "2029"

            @test isapprox(testqry[1,:val], 3845.15703404259; atol=TOL)
            @test isapprox(testqry[2,:val], 146.55227050539; atol=TOL)
            @test isapprox(testqry[3,:val], 139.57362837926; atol=TOL)
            @test isapprox(testqry[4,:val], 132.927266053843; atol=TOL)
            @test isapprox(testqry[5,:val], 126.597396376304; atol=TOL)
            @test isapprox(testqry[6,:val], 120.568948487497; atol=TOL)
            @test isapprox(testqry[7,:val], 114.827569988092; atol=TOL)
            @test isapprox(testqry[8,:val], 109.35959046485; atol=TOL)
            @test isapprox(testqry[9,:val], 104.151990918904; atol=TOL)
            @test isapprox(testqry[10,:val], 99.1923723037184; atol=TOL)
        end

        # Test with restrictvars
        NemoMod.calculatescenario(dbfile; jumpmodel = JuMP.Model(CPLEX.Optimizer),
            varstosave = "vrateofproductionbytechnologybymode, vrateofusebytechnologybymode, vproductionbytechnology, vusebytechnology, "
                * "vtotaldiscountedcost",
            restrictvars = true, quiet = false)

        if !compilation
            testqry = SQLite.DBInterface.execute(db, "select * from vtotaldiscountedcost") |> DataFrame

            @test testqry[1,:y] == "2020"
            @test testqry[2,:y] == "2021"
            @test testqry[3,:y] == "2022"
            @test testqry[4,:y] == "2023"
            @test testqry[5,:y] == "2024"
            @test testqry[6,:y] == "2025"
            @test testqry[7,:y] == "2026"
            @test testqry[8,:y] == "2027"
            @test testqry[9,:y] == "2028"
            @test testqry[10,:y] == "2029"

            @test isapprox(testqry[1,:val], 3845.15703404259; atol=TOL)
            @test isapprox(testqry[2,:val], 146.55227050539; atol=TOL)
            @test isapprox(testqry[3,:val], 139.57362837926; atol=TOL)
            @test isapprox(testqry[4,:val], 132.927266053843; atol=TOL)
            @test isapprox(testqry[5,:val], 126.597396376304; atol=TOL)
            @test isapprox(testqry[6,:val], 120.568948487497; atol=TOL)
            @test isapprox(testqry[7,:val], 114.827569988092; atol=TOL)
            @test isapprox(testqry[8,:val], 109.35959046485; atol=TOL)
            @test isapprox(testqry[9,:val], 104.151990918904; atol=TOL)
            @test isapprox(testqry[10,:val], 99.1923723037184; atol=TOL)
        end

        # Test with storage net zero constraints
        SQLite.DBInterface.execute(db, "update STORAGE set netzeroyear = 1")
        NemoMod.calculatescenario(dbfile; jumpmodel = Model(CPLEX.Optimizer), restrictvars=false)

        if !compilation
            testqry = SQLite.DBInterface.execute(db, "select * from vtotaldiscountedcost") |> DataFrame

            @test testqry[1,:y] == "2020"
            @test testqry[2,:y] == "2021"
            @test testqry[3,:y] == "2022"
            @test testqry[4,:y] == "2023"
            @test testqry[5,:y] == "2024"
            @test testqry[6,:y] == "2025"
            @test testqry[7,:y] == "2026"
            @test testqry[8,:y] == "2027"
            @test testqry[9,:y] == "2028"
            @test testqry[10,:y] == "2029"

            @test isapprox(testqry[1,:val], 3840.94023817782; atol=TOL)
            @test isapprox(testqry[2,:val], 459.29493842479; atol=TOL)
            @test isapprox(testqry[3,:val], 437.423750880753; atol=TOL)
            @test isapprox(testqry[4,:val], 416.59404845786; atol=TOL)
            @test isapprox(testqry[5,:val], 396.756236626533; atol=TOL)
            @test isapprox(testqry[6,:val], 377.86308250146; atol=TOL)
            @test isapprox(testqry[7,:val], 359.8696023823438; atol=TOL)
            @test isapprox(testqry[8,:val], 342.73295464985; atol=TOL)
            @test isapprox(testqry[9,:val], 326.412337761762; atol=TOL)
            @test isapprox(testqry[10,:val], 310.86889310644; atol=TOL)
        end

        SQLite.DBInterface.execute(db, "update STORAGE set netzeroyear = 0")

        # Test with calcyears
        NemoMod.calculatescenario(dbfile; jumpmodel = Model(CPLEX.Optimizer), restrictvars=true,
            calcyears=[2020,2029])

        if !compilation
            testqry = SQLite.DBInterface.execute(db, "select * from vtotaldiscountedcost") |> DataFrame

            @test testqry[1,:y] == "2020"
            @test testqry[2,:y] == "2029"

            @test isapprox(testqry[1,:val], 3840.94023817781; atol=TOL)
            @test isapprox(testqry[2,:val], 3427.81584479179; atol=TOL)
        end

        # Test MinimumUtilization
        SQLite.DBInterface.execute(db, "insert into MinimumUtilization select ROWID, '1', 'gas', val, 2025, 0.5 from TIMESLICE")
        NemoMod.calculatescenario(dbfile; jumpmodel = Model(CPLEX.Optimizer), varstosave="vproductionbytechnologyannual")

        if !compilation
            testqry = SQLite.DBInterface.execute(db, "select * from vproductionbytechnologyannual where t = 'gas' and y = 2025") |> DataFrame

            @test isapprox(testqry[1,:val], 15.768; atol=TOL)
        end

        SQLite.DBInterface.execute(db, "delete from MinimumUtilization")

        # Delete test results and re-compact test database
        NemoMod.dropresulttables(db)
        testqry = SQLite.DBInterface.execute(db, "VACUUM")
    end  # "Solving storage_test with CPLEX"

    @testset "Solving storage_transmission_test with CPLEX" begin
        dbfile = joinpath(@__DIR__, "storage_transmission_test.sqlite")
        #dbfile = "c:/temp/storage_transmission_test.sqlite"
        chmod(dbfile, 0o777)  # Make dbfile read-write. Necessary because after Julia 1.0, Pkg.add makes all package files read-only

        NemoMod.calculatescenario(dbfile; jumpmodel = JuMP.Model(CPLEX.Optimizer),
            varstosave =
                "vdemandnn, vnewcapacity, vtotalcapacityannual, vproductionbytechnologyannual, vproductionnn, vusebytechnologyannual, vusenn, vtotaldiscountedcost, "
                * "vtransmissionbuilt, vtransmissionexists, vtransmissionbyline, vtransmissionannual",
            restrictvars=false, quiet = false)

        db = SQLite.DB(dbfile)

        if !compilation
            testqry = SQLite.DBInterface.execute(db, "select * from vtotaldiscountedcost") |> DataFrame

            @test testqry[1,:y] == "2020"
            @test testqry[2,:y] == "2021"
            @test testqry[3,:y] == "2022"
            @test testqry[4,:y] == "2023"
            @test testqry[5,:y] == "2024"
            @test testqry[6,:y] == "2025"
            @test testqry[7,:y] == "2026"
            @test testqry[8,:y] == "2027"
            @test testqry[9,:y] == "2028"
            @test testqry[10,:y] == "2029"

            @test isapprox(testqry[1,:val], 9786.56626042587; atol=TOL)
            @test isapprox(testqry[2,:val], 239.495064739257; atol=TOL)
            @test isapprox(testqry[3,:val], 228.090641826873; atol=TOL)
            @test isapprox(testqry[4,:val], 217.229273833058; atol=TOL)
            @test isapprox(testqry[5,:val], 206.884786725342; atol=TOL)
            @test isapprox(testqry[6,:val], 197.033272788862; atol=TOL)
            @test isapprox(testqry[7,:val], 187.650830607229; atol=TOL)
            @test isapprox(testqry[8,:val], 178.714951753762; atol=TOL)
            @test isapprox(testqry[9,:val], 170.204748803116; atol=TOL)
            @test isapprox(testqry[10,:val], 162.099761418328; atol=TOL)
        end

        # Test MinimumUtilization
        SQLite.DBInterface.execute(db, "insert into MinimumUtilization select ROWID, '1', 'gas', val, 2025, 0.2 from TIMESLICE")
        NemoMod.calculatescenario(dbfile; jumpmodel = Model(CPLEX.Optimizer), varstosave="vproductionbytechnologyannual", calcyears=[2020,2025,2029])

        if !compilation
            testqry = SQLite.DBInterface.execute(db, "select * from vproductionbytechnologyannual where t = 'gas' and y = 2025") |> DataFrame

            @test isapprox(testqry[1,:val], 16.3149963697108; atol=TOL)
        end

        SQLite.DBInterface.execute(db, "delete from MinimumUtilization")

        # Test interest rates
        SQLite.DBInterface.execute(db, "insert into InterestRateStorage select rowid, 1, 'storage1', y.val, 0.05 from year y")
        SQLite.DBInterface.execute(db, "insert into InterestRateTechnology select rowid, 1, 'solar', y.val, 0.05 from year y")
        SQLite.DBInterface.execute(db, "update TransmissionLine set interestrate = 0.05 where id = 2")
        NemoMod.calculatescenario(dbfile; jumpmodel = Model(CPLEX.Optimizer), varstosave="vtotaldiscountedcost", calcyears=[2020,2025,2029])

        if !compilation
            testqry = SQLite.DBInterface.execute(db, "select * from vtotaldiscountedcost") |> DataFrame

            @test testqry[1,:y] == "2020"
            @test testqry[2,:y] == "2025"
            @test testqry[3,:y] == "2029"

            @test isapprox(testqry[1,:val], 12672.8114711738; atol=TOL)
            @test isapprox(testqry[2,:val], 2510.44588849556; atol=TOL)
            @test isapprox(testqry[3,:val], 1611.02249720726; atol=TOL)
        end

        SQLite.DBInterface.execute(db, "delete from InterestRateStorage")
        SQLite.DBInterface.execute(db, "delete from InterestRateTechnology")
        SQLite.DBInterface.execute(db, "update TransmissionLine set interestrate = null where id = 2")

        # Test transshipment power flow
        SQLite.DBInterface.execute(db, "update TransmissionModelingEnabled set type = 3")
        SQLite.DBInterface.execute(db, "update TransmissionLine set efficiency = 0.9")
        NemoMod.calculatescenario(dbfile; jumpmodel = Model(CPLEX.Optimizer), varstosave="vtotaldiscountedcost", calcyears=[2020,2025,2029])

        if !compilation
            testqry = SQLite.DBInterface.execute(db, "select * from vtotaldiscountedcost") |> DataFrame
            @test testqry[1,:y] == "2020"
            @test testqry[2,:y] == "2025"
            @test testqry[3,:y] == "2029"

            @test isapprox(testqry[1,:val], 4855.79076447287; atol=TOL)
            @test isapprox(testqry[2,:val], 2687.29032799192; atol=TOL)
            @test isapprox(testqry[3,:val], 1738.34669443912; atol=TOL)
        end

        SQLite.DBInterface.execute(db, "update TransmissionModelingEnabled set type = 2")
        SQLite.DBInterface.execute(db, "update TransmissionLine set efficiency = null")

        # Delete test results and re-compact test database
        NemoMod.dropresulttables(db)
        testqry = SQLite.DBInterface.execute(db, "VACUUM")
    end  # "Solving storage_transmission_test with CPLEX"

    @testset "Solving ramp_test with CPLEX" begin
        dbfile = joinpath(@__DIR__, "ramp_test.sqlite")
        #dbfile = "c:/temp/ramp_test.sqlite"
        chmod(dbfile, 0o777)  # Make dbfile read-write. Necessary because after Julia 1.0, Pkg.add makes all package files read-only

        NemoMod.calculatescenario(dbfile; jumpmodel = JuMP.Model(CPLEX.Optimizer), quiet = false)

        db = SQLite.DB(dbfile)

        if !compilation
            testqry = SQLite.DBInterface.execute(db, "select * from vtotaldiscountedcost") |> DataFrame

            @test testqry[1,:y] == "2020"
            @test testqry[2,:y] == "2021"
            @test testqry[3,:y] == "2022"
            @test testqry[4,:y] == "2023"
            @test testqry[5,:y] == "2024"
            @test testqry[6,:y] == "2025"
            @test testqry[7,:y] == "2026"
            @test testqry[8,:y] == "2027"
            @test testqry[9,:y] == "2028"
            @test testqry[10,:y] == "2029"

            @test isapprox(testqry[1,:val], 4163.77771390785; atol=TOL)
            @test isapprox(testqry[2,:val], 1606.0180127748; atol=TOL)
            @test isapprox(testqry[3,:val], 1529.54096454743; atol=TOL)
            @test isapprox(testqry[4,:val], 1456.70568052136; atol=TOL)
            @test isapprox(testqry[5,:val], 1387.33874335368; atol=TOL)
            @test isapprox(testqry[6,:val], 1321.27499367017; atol=TOL)
            @test isapprox(testqry[7,:val], 1258.35713682873; atol=TOL)
            @test isapprox(testqry[8,:val], 1198.43536840832; atol=TOL)
            @test isapprox(testqry[9,:val], 1141.36701753173; atol=TOL)
            @test isapprox(testqry[10,:val], 1084.83029580609; atol=TOL)
        end

        # Delete test results and re-compact test database
        NemoMod.dropresulttables(db)
        testqry = SQLite.DBInterface.execute(db, "VACUUM")
    end  # "Solving ramp_test with CPLEX"

    GC.gc()
end  # @isdefined CPLEX
