# Marek Traczyński (261748)
# Obliczenia Naukowe
# Lista 3 Zadanie 5


include("./functions.jl")
using .RootsFunctions


function main()
    # Funkcja f(x) = e^x - 3*x
    func::Function = x -> exp(x) - 3.0 * x 

    # Dokładności obliczeń
    delta::Float64 = 10.0 ^ -4
    epsilon::Float64 = 10.0 ^ -4

    # Przedziały, w których szukamy rozwiązania
    abvalues::Vector{Tuple{Float64, Float64}} = [(0.0, 1.0),
                                                 (1.0, 2.0)]

    # Struktura z rozwiązaniem
    result::RootFuncResult = RootFuncResult(0.0, 0.0, 0, 0)


    print("\n====================================================\n")

    for interval in abvalues
        result = mbisekcji(func,
                           interval[1], interval[2],
                           delta, epsilon)
        print("\n>>> Bisection method test results for $func:\n")
        println(" |--> r = $(result.root)")
        println(" |--> v = $(result.rootvalue)")
        println(" |--> it = $(result.iterations)")
        println(" |--> err = $(result.error)")
    end

    print("\n====================================================\n\n")
end

main()