using DataFrames
import CSV
using Plots
default(formatter=identity)
using Statistics
using Pipe: @pipe
pr = DataFrame(CSV.File("data/prs.csv"))
issues = DataFrame(CSV.File("data/issues.csv"))
total = DataFrame(CSV.File("data/repos.csv"))
include("utils.jl")

total[findall(in(["R", "Julia"]), total[:, :language]), :] |>
df -> bar(df[:, :language], df[:, :num_repos], g=df[:, :language],
      fill=["#2B5FE9", "#AA30FF"])
using PrettyTables


lag(x) = [x[i] - x[i-1] for i in 2:length(x)]

@pipe pr |>
      groupby(_, [:year, :name]) |>
      combine(_, :count => (lag => :lag))

fav_langs = function (df::DataFrame, langs::Vector)
      @pipe df[findall(in(langs), df[!, :name]), :] |>
            groupby(_, [:year, :name])
end

lagged = @pipe issues[issues.year.>2016, :] |>
               groupby(_, [:year, :name]) |>
               combine(_, :count => (mean => :media)) |>
               groupby(_, :name) |>
               combine(_, :media => (lag => :lag))




years = @pipe pr[2017 .< pr.year .< 2022, :] |>
              select(_, :year) |>
              unique(_)



pqp(x) = x + 1

#lagado = @pipe lagged[Not(1), :] |> 
hcat(_, vcat(years, years))



lagado[:, :lag] = @pipe ifelse.(lagado[:, :lag] .> 0, 1, 0)

@pipe lagado |>
      groupby(_, :name) |>
      combine(_, :lag => sum) |>
      sort(_, :lag_sum, rev=true) |>
      first(_, 5) |> println


default(size=(1200, 700))
@pipe fav_langs(pr, ["Nix", "SCSS", "Dart", "Verilog", "Jsonnet"]) |>
      df -> plot(df[:, :year], df[:, :media], g=df[:, :name], size=(1200, 700))


years = @pipe pr[2017 .< pr.year .< 2022, :] |>
              select(_, :year) |>
              unique(_)



pqp(x) = x + 1

lagado = @pipe lagged[Not(1), :] |>
               hcat(_, vcat(years, years))

HTMLTableFormat("tf_html_dark")
issues |> size

@pipe pr |>
      groupby(_, var) |>
      combine(_, :count => (sum => :total)) |>
      sort(_, :total, rev=true) |>
      first(_, 5)

@pipe top_5_count(issues, :name) |>
      df -> bar(df[:, :total], orientation=:h, yticks=(df[:, :total], ["JS", "py", "java", "php", "c"]), yflip=true)

ticklabel = string.(collect("C++", "JAVA"))
bar(1:2, orientation=:h, yticks=(1:2, ["C", "JAVA"]), yflip=true)

top_5_count(pr, :name)
string.(collect((top_5_count(issues, :name)[:, :name])))


bar(Vector(1:5), orientation=:h, yticks=(Vector(1:5), ["J", "B", "C", "D", "E"]))

top_5_count(pr, :name)[:, :name] |> Vector
["A", "B", "C", "D", "E"]






x = top_5_count(issues, :name)[:, :total]
y = top_5_count(issues, :name)[:, :name]
bar(x, orientation=:h, yticks=(1:5, y), legend=false, yflip=true, fill=vcat(["#f3ff33", "#337aff",
      "#ce640c", "#b60000", "#5310c8"]),xticks = 0:2*10^6:7.5*10^6)

barh(issues, ["#b60000","#0b08c0"])


x = ["Q","W"]

bar(["A","B","C","D"],[1,2,3,4], markersize = 10, bar_width = 0.2)
scatter!(["A","B","C","D"],[1,2,3,4], markersize = 1, c = ["#f3ff33", "#337aff",
"#ce640c", "#b60000", "#5310c8"], series_annotations = ["A","B","C","D"])


["A","B"] |> text
x = ["A","B","C","D"]
y= [1,2,3,4]

bar(x, y, texts=y)

text(x[3], 5)

using Printf, Plots
super_bar = function (df::DataFrame, v1::Symbol, v2::Symbol)
      x = df[:,v1]
      x1 = [0.5:1:(x  |> length);]
      y = df[:, v2]
      str = [(@sprintf("%.0f", yi),9) for yi in y] 
      (ymin,ymax) = extrema(y)
      dy = 0.04*(ymax-ymin)
      Plots.bar(x,y, title="SUPER!",legend=false)
      annotate!(x1,y.+dy, str, ylim = (0,ymax+2dy))

end






#[0.5:1:4;]

data = top_5_count(pr,:name)

super_bar(data, :name, :total)



total[findall(in(["R", "Julia"]), total[:, :language]), :] |>
df -> super_bar(df, :language, :num_repos,["#2B5FE9", "#AA30FF"])


lagged = @pipe issues[issues.year.>2016, :] |>
               groupby(_, [:year, :name]) |>
               combine(_, :count => mean) |>
               groupby(_, :name) |>
               combine(_, :count_mean => (lag => :count));
lagged[:, :count] =  ifelse.(lagged[:, :count] .> 0, 1, 0);

top_5_count(lagged, :name)  |> 
df -> pretty_table(df, backend = Val(:latex), header = names(df),tf=tf_latex_modern)


