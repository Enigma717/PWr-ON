# Marek Traczyński (261748)
# Obliczenia Naukowe
# Lista 4 Zadanie 6


include("./interpolation.jl")
using .Interpolation


function main()
    # Wektor z funkcjami
    functions::Vector{Function} = [x -> abs(x),
                                   x -> 1.0 / (1 + x ^ 2)] 
 
    # Wektor z przedziałami jako krotki
    abvalues::Vector{Tuple{Float64, Float64}} = [(-1.0, 1.0),
                                                 (-5.0, 5.0)]
    # Wektor z wartościami n
    nvalues::Vector{Int} = [5,
                            10,
                            15]


    foreach(rm, filter(endswith(".png"), readdir("./plots/zad6/", join = true)))
    for (index, func) in enumerate(functions)
        print("\n====================================================\n")
        print("\n>>> Function number $func <<\n")
        for n in nvalues
            filepath = "./plots/zad6/intpolfun$(index)n$(n).png"
            rysujnnfx(func, abvalues[index][1], abvalues[index][2], n, filepath)
            
            println(" |--> Saved plot for n = $n as $filepath <<")
        end
    end
    
    print("\n====================================================\n\n")
end

main()