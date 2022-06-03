using DataFrames
import CSV
using Plots
default(formatter=identity)
using Statistics
using Pipe: @pipe

top_5 = function (df::DataFrame, variable::Symbol)
    @pipe df |>
          groupby(_, variable) |>
          combine(_, :count => mean => :media)
end

fav_langs = function (df::DataFrame, langs::Vector)
    @pipe df[findall(in(langs), df[!, :name]), :] |>
          groupby(_, [:year, :name]) |>
          combine(_, :count => (mean => :media))

end

lag(x) = [x[i] - x[i-1] for i in 2:length(x)]

