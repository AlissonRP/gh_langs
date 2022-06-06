using DataFrames
import CSV
using Plots
default(formatter=identity, tickfontsize=7, titlefontsize=12,
    legend=:topleft)
using Statistics
using Pipe: @pipe
using Printf

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

barh = function (df::DataFrame, lc::Vector)
    x = top_5_count(df, :name)[:, :total]
    y = top_5_count(df, :name)[:, :name]
    bar(x, orientation=:h, yticks=(1:5, y), legend=false, yflip=true, fill=vcat(["#f3ff33", "#337aff",
                "#ce640c"], lc), xticks=0:2*10^6:7.5*10^6)
end



using Printf, Plots
super_bar = function (df::DataFrame, v1::Symbol, v2::Symbol, colors::Vector)
    x = df[:, v1]
    x1 = [0.5:1:(x|>length);]
    y = df[:, v2]
    str = [(@sprintf("%.0f", yi), 8) for yi in y]
    (ymin, ymax) = extrema(y)
    dy = 0.05 * (ymax - ymin)
    Plots.bar(x, y, legend=false, f = colors)
    annotate!(x1, y .+ dy, str, ylim=(0, ymax + 2dy))

end

