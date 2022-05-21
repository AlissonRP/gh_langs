using DataFrames
import CSV
using Plots
default(formatter=identity)
using Statistics
using Pipe: @pipe
pr = DataFrame(CSV.File("data/prs.csv"))
issues = DataFrame(CSV.File("data/issues.csv"))
total = DataFrame(CSV.File("data/repos.csv"))

top_5 = function (df,variable)
    @pipe df |> 
    groupby(_, variable) |> 
    combine(_, :count => mean => :media)
end