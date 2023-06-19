using Distributions
using StatisticalRethinking
using StatsPlots
using Logging
using LaTeXStrings
using DataFrames
using AlgebraOfGraphics
using CairoMakie
using Turing
using AbstractMCMC

default(labels=false)

ways = [0, 3, 8, 9, 0]
ways = ways ./ sum(ways)
println(ways)

b = Binomial(9, 0.5)
ways = ways ./ sum(ways)
pdf(b, 6)

uniform_prior(p_grid) = fill(1, length(p_grid))
truncated_prior(p_grid) = ifelse.(p_grid .< 0.5, 0, 1)
double_exp_prior(p_grid) = exp.(-5 * abs.(p_grid .- 0.5))

function grid_approximation(prior_func, grid_size, successes, trials)
    p_grid = collect(range(0, 1, length = grid_size))
    prior = prior_func(p_grid)
    likelihood = pdf.(Binomial.(trials, p_grid), successes)

    unstd_posterior = likelihood .* prior
    posterior = unstd_posterior / sum(unstd_posterior)

    return Dict(
        "p_grid" => p_grid,
        "posterior" => posterior
    )
end

p_grid = collect(range(0, 1, length=20))
prior = fill(1, 20)
likelihood = pdf.(Binomial.(9, p_grid), 6)
unstd_posterior = likelihood .* prior
posterior = unstd_posterior / sum(unstd_posterior)

grids = [5, 20]

uniform_grids = map(grid -> grid_approximation(uniform_prior, grid, 6, 9), grids)

grid_5 = DataFrame(uniform_grids[1])
grid_20 = DataFrame(uniform_grids[2])

grid_5_plot = data(grid_5) * mapping(:p_grid, :posterior) * visual(Lines)
grid_20_plot = data(grid_20) * mapping(:p_grid, :posterior) * visual(Lines)

draw(grid_5_plot)
draw(grid_20_plot)

truncated_grids = map(grid -> grid_approximation(truncated_prior, grid, 6, 9), grids)

grid_5 = DataFrame(truncated_grids[1])
grid_20 = DataFrame(truncated_grids[2])

grid_5_plot = data(grid_5) * mapping(:p_grid, :posterior) * visual(Lines)
grid_20_plot = data(grid_20) * mapping(:p_grid, :posterior) * visual(Lines)

draw(grid_5_plot)
draw(grid_20_plot)

double_exp_grids = map(grid -> grid_approximation(double_exp_prior, grid, 6, 9), grids)

grid_5 = DataFrame(double_exp_grids[1])
grid_20 = DataFrame(double_exp_grids[2])

grid_5_plot = data(grid_5) * mapping(:p_grid, :posterior) * visual(Lines)
grid_20_plot = data(grid_20) * mapping(:p_grid, :posterior) * visual(Lines)

@model function binomial_model(N, y)
    p ~ Uniform(0, 1)
    y ~ Binomial(N, p)
    return y
end

chain = sample(binomial_model(9, 6), NUTS(), MCMCThreads(), 1000, 4)
DataFrame(chain)


df = (; x = p_grid, y = pdf.(Binomial.(2, p_grid), 1))

layer = data(df) * mapping(:x, :y) * visual(Lines)
draw(layer)

grid_size = 50
df = (; obs_1 = [1, 1, 1], obs_2 = [1, 1, 1, 0], obs_3 = [0, 1, 1, 0, 1, 1, 1])

tosses = Dict()

function simulate_tosses(df, prior_func, grid_size)
    tosses = Dict()

    for obs in keys(df)
        w = sum(df[obs])
        n = length(df[obs])
        tosses[obs] = grid_approximation(prior_func, grid_size, w, n)
    end

    obs_1 = tosses[:obs_1]
    obs_2 = tosses[:obs_2]
    obs_3 = tosses[:obs_3]

    tosses_data = vcat(DataFrame.([obs_1, obs_2, obs_3])..., source = :source => ["obs_1", "obs_2", "obs_3"])
    return tosses_data
end


for obs in keys(df)
    w = sum(df[obs])
    n = length(df[obs])
    tosses[obs] = grid_approximation(uniform_prior, grid_size, w, n)
end

tosses

obs_1 = tosses[:obs_1]
obs_2 = tosses[:obs_2]
obs_3 = tosses[:obs_3]

uniform_tosses = simulate_tosses(df, uniform_prior, grid_size)

uniform_layer = data(uniform_tosses) *
    mapping(:p_grid, :posterior, col = :source) *
    visual(Lines)
draw(uniform_layer, facet = (; linkyaxes = :none))

