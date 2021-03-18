```@meta
CurrentModule = NemoMod
```
# [Performance tips](@id performance_tips)

NEMO is designed to provide robust performance for a wide variety of models and scenarios. However, it is certainly possible to build a NEMO model that calculates slowly. Most often, this is due to a long solve time (i.e., the solver takes a long time to find a solution), which in turn is driven by model complexity.

If your model isn't calculating as quickly as you'd like, there are several steps to consider.

1. **Only save the output variables you need.** Saving unnecessary [variables](@ref variables) increases disk operations and may result in a longer solve time (because additional constraints are needed to calculate the variables).

2. **Don't save zeros.** If you set the `reportzeros` argument for [`calculatescenario`](@ref) to `false` (the default), NEMO won't save output variable values that are equal to zero. This can substantially reduce the time and disk space needed to write scenario outputs.

3. **Check `restrictvars`.** The `restrictvars` argument for [`calculatescenario`](@ref) can have an important effect on performance. This option tells NEMO to make a greater effort to eliminate unnecessary variables from the model it provides to the solver. This filtering process requires a little time, but it can considerably reduce the solver's work load. In general, the trade-off is advisable for large models (you should set `restrictvars` to `true` in these cases) but may not be for very small models (set `restrictvars` to `false` in these cases).

4. **Use parallel processing.** NEMO can parallelize certain operations, reducing their run time by spreading the load across multiple processes. To enable parallelization, use the `numprocs` or `targetprocs` argument with [`calculatescenario`](@ref). `numprocs` lets you choose the number of parallel processes to run, while with `targetprocs` you can select specific processes for parallelization by their Julia identifier (see the Julia documentation on distributed computing for more information on process identifiers and initialization). The default value for `numprocs` is 0, which means NEMO will set the number of parallel processes based your computer's hardware. As needed, it will start additional processes for you.

   Note that `numprocs` and `targetprocs` affect parallelization in NEMO's Julia code, but they don't control what happens with the solver. For maximum performance with large models, it's also helpful to use a solver that supports parallelization, such as CPLEX, Gurobi, or Cbc.

5. **Simplify the scenario.** Substantial performance gains can be realized by reducing the number of [dimensions](@ref dimensions) in a scenario - for example, decreasing the number of [regions](@ref region), [technologies](@ref technology), [time slices](@ref timeslice), [years](@ref year), or [nodes](@ref node). You can also speed up calculations by forgoing nodal transmission modeling. Of course, this approach generally requires trade-offs: a simpler model may not respond as well to the analytic questions you are asking. The goal is to find a reasonable balance between your model's realism and its performance.

6. **Relax the transmission simulation.** If you're simulating transmission, there are some other performance tuning options to consider beyond reducing your model's dimensions. You can change the simulation method with the [`TransmissionModelingEnabled`](@ref TransmissionModelingEnabled) parameter or use this parameter to model transmission only in selected [years](@ref year). The [`calculatescenario`](@ref) function also has an argument (`continuoustransmission`) that determines whether NEMO uses binary or continuous variables to represent the construction of candidate [transmission lines](@ref transmissionline). With binary variables (`continuoustransmission = false`) candidate lines may only be built in their entirety, while with continuous variables (`continuoustransmission = true`) partial line construction is allowed. Continuous simulations are generally faster but may not be as realistic.

7. **Use [`CapacityOfOneTechnologyUnit`](@ref CapacityOfOneTechnologyUnit) selectively.** This parameter sets the minimum increment for endogenously determined capacity additions for a [technology](@ref technology). When it's specified, NEMO uses integer variables to solve for capacity, which increases model solve time. If you don't define `CapacityOfOneTechnologyUnit`, NEMO solves for technology capacity with continuous variables. This approach assumes that any increment of new capacity is permissible (subject to limits on minimum and maximum capacity and capacity investment - see [`TotalAnnualMinCapacity`](@ref TotalAnnualMinCapacity), [`TotalAnnualMaxCapacity`](@ref TotalAnnualMaxCapacity), [`TotalAnnualMinCapacityInvestment`](@ref TotalAnnualMinCapacityInvestment), and [`TotalAnnualMaxCapacityInvestment`](@ref TotalAnnualMaxCapacityInvestment)).

8. **Try a different solver.** The open-source solvers delivered with NEMO (GLPK and Cbc) may struggle with sizeable models. If you have access to one of the commercial solvers NEMO supports (currently, CPLEX, Gurobi, Mosek, and Xpress), it will usually be a better option. If you're choosing between Cbc and GLPK, test both of them to see which performs better for your scenario.