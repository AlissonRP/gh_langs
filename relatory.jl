using DataFrames
import CSV
using Plots
using Statistics
pr = DataFrame(CSV.File("data/prs.csv"))
issues = DataFrame(CSV.File("data/issues.csv"))
total = DataFrame(CSV.File("data/repos.csv"))


total |>
d -> sort(d, order(:num_repos, rev=true)) |>
     d -> first(d, 5) |> 
     d -> select(d, :"language" => :"Linguagem",:"num_repos" => :"N") |> 
     d -> bar(d.Linguagem,d.N)


data = groupby(df, [:name]) |> d -> combine(d, :count => (sum => :total))



df[(df.name.==["Julia"]).|(df.name.==["R"]).|(df.name.==["Python"]), :] |>
d -> groupby(d, [:year, :name]) |>
     d -> combine(d, :count => (mean => :media)) |>
          d -> plot(d, x=:year, y=:media, Geom.line, color=:name)

p = plot()
push!(p, layer(x=[2, 4], y=[2, 4], size=[1.4142], color=[colorant"gold"]))
push!(p, Coord.cartesian(fixed=true))