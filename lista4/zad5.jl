# Marek Traczyński (261748)
# Obliczenia Naukowe
# Lista 4 Zadanie 5


include("./interpolation.jl")
using .Interpolation


function main()
    # Wektor z funkcjami
    functions::Vector{Function} = [x -> exp(x),
                                   x -> (x ^ 2) * sin(x)]
 
    # Wektor z przedziałami jako krotki
    abvalues::Vector{Tuple{Float64, Float64}} = [(0.0, 1.0),
                                                 (-1.0, 1.0)]
    # Wektor z wartościami n
    nvalues::Vector{Int} = [5,
                            10,
                            15]


    foreach(rm, filter(endswith(".png"), readdir("./plots/zad5/", join = true)))
    for (indexi, func) in enumerate(functions)
        print("\n====================================================\n")
        print("\n>>> Function number $func <<\n")
        for n in nvalues
            filepath = "./plots/zad5/intpol$(func)n$(n).png"
            rysujnnfx(func, abvalues[indexi][1], abvalues[indexi][2], n, filepath)
            
            println(" |--> Saved plot for n = $n as $filepath <<")
        end
    end
    
    print("\n====================================================\n\n")
end

main()