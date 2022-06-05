using DataFrames
import CSV
using Plots
default(formatter=identity, tickfontsize=7, titlefontsize=12,
    legend=:topleft)
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

top_5_count = function (df::DataFrame, var::Symbol)
    @pipe df |>
          groupby(_, var) |>
          combine(_, :count => sum => :total) |>
          sort(_, :total, rev=true) |>
          first(_, 5)
end

barh = function (df::DataFrame, lc::String)
    x = top_5_count(df, :name)[:, :total]
    y = top_5_count(df, :name)[:, :name]
    bar(x, orientation=:h, yticks=(1:5, y), legend=false, yflip=true, fill=["#f3ff33", "#337aff",
            "#ce640c", "#b60000", lc], xticks=0:2*10^6:7.5*10^6)
end