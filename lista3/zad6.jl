# Marek Traczyński (261748)
# Obliczenia Naukowe
# Lista 3 Zadanie 6


include("./functions.jl")
using .RootsFunctions


function main()
    # Wektory z funkcjami i ich pochodne
    functions::Vector{Function} = [x -> exp(1.0 - x) - 1.0,
                                   x -> x * exp(-x)] 
    derivatives::Vector{Function} = [x -> -exp(1.0 - x),
                                     x -> -exp(-x) * (x - 1.0)] 

    # Dokładności obliczeń
    delta::Float64 = 10.0 ^ -5
    epsilon::Float64 = 10.0 ^ -5

    # Wektory z argumentami funkcji
    abvalues::Vector{Tuple{Float64, Float64}} = [(0.4, 1.4),
                                                 (-0.7, 0.3)]
    secantxvalues::Vector{Tuple{Float64, Float64}} = [(0.4, 1.4)
                                                      (-0.7, 0.3)]
    newtonxvalues::Vector{Float64} = [0.5, 
                                      0.5]
    maxitvalues::Vector{Int} = [64,
                                64]

    # Struktura z rozwiązaniem
    result::RootFuncResult = RootFuncResult(0.0, 0.0, 0, 0)


    for (index, func) in enumerate(functions)
        print("\n====================================================\n")

        result = mbisekcji(func,
                           abvalues[index][1], abvalues[index][2],
                           delta, epsilon)
        print("\n>>> Bisection method test results for $func:\n")
        println(" |--> r = $(result.root)")
        println(" |--> v = $(result.rootvalue)")
        println(" |--> it = $(result.iterations)")
        println(" |--> err = $(result.error)")
        
        print("\n----------------------------------------\n")

        result = mstycznych(func, derivatives[index],
                            newtonxvalues[index],
                            delta, epsilon, 
                            maxitvalues[index])
        print("\n>>> Newton's method test results for $func:\n")
        println(" |--> r = $(result.root)")
        println(" |--> v = $(result.rootvalue)")
        println(" |--> it = $(result.iterations)")
        println(" |--> err = $(result.error)")

        print("\n----------------------------------------\n")

        result = msiecznych(func, 
                            secantxvalues[index][1], secantxvalues[index][2],
                            delta, epsilon, 
                            maxitvalues[index])
        print("\n>>> Secant method test results for $func:\n")
        println(" |--> r = $(result.root)")
        println(" |--> v = $(result.rootvalue)")
        println(" |--> it = $(result.iterations)")
        println(" |--> err = $(result.error)")
    end
    
    
    for value::Int in 2:20
        print("\n====================================================\n")
        
        result = mstycznych(functions[1], derivatives[1],
                            Float64(value),
                            delta, epsilon, 
                            maxitvalues[1])
        print("\n>>> Newton's method test results for $(functions[1]) and x0 = $value:\n")
        println(" |--> r = $(result.root)")
        println(" |--> v = $(result.rootvalue)")
        println(" |--> it = $(result.iterations)")
        println(" |--> err = $(result.error)")

        print("\n----------------------------------------\n")

        result = mstycznych(functions[2], derivatives[2],
                            Float64(value),
                            delta, epsilon, 
                            maxitvalues[2])
        print("\n>>> Newton's method test results for $(functions[2]) and x0 = $value:\n")
        println(" |--> r = $(result.root)")
        println(" |--> v = $(result.rootvalue)")
        println(" |--> it = $(result.iterations)")
        println(" |--> err = $(result.error)")
    end

    print("\n====================================================\n\n")

end

main()