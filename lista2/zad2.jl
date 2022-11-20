# Marek Traczyński (261748)
# Obliczenia Naukowe
# Lista 2 Zadanie 2


using Plots


function main()
    func(x)::Float64 = exp(Float64(x)) * log(Float64(1.0) + exp(Float64(-x)))

    funcplot = plot(func,
                    title = "f(x) = e^x * ln(1 + e^-x)",
                    label = "f(x)",
                    xlims = (0.0, 50.0),
                    xticks = 0.0:5.0:50.0,
                    ylims = (0.0, 2.0),
                    linecolor = :red,
                    lw = 2)

    Plots.png(funcplot, "zad2.png")
end


main()