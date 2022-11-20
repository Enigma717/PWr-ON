# Marek Traczyński (261748)
# Obliczenia Naukowe
# Lista 2 Zadanie 5


# Obliczanie rekurencyjnie modelu wzrostu populacji
function growthmodel(n::Integer, r::AbstractFloat, p::AbstractFloat, type::DataType)
    if n == 0
        return p
    end

    pn::type = growthmodel(n - 1, r, p, type) 

    return pn + (r * pn * (one(type) - pn))
end
    

function main()
    types::Vector{DataType} = [Float32, Float64]

    
    print("\n====================================================\n")

    for type in types
        realresult::type = growthmodel(40, type(3), type(0.01), type)
        
        truncresult::type = growthmodel(10, type(3), type(0.01), type)
        newp::type = trunc(truncresult, digits = 3, base = 10)
        truncresult = growthmodel(30, type(3), newp, type)

        print("\n>>> $type test results:\n") 
        println(" |--> Without truncating: $realresult") 
        println(" |--> With truncating: $truncresult") 
        println("  \\--> Truncation point: $newp") 
    end
    
    print("\n====================================================\n\n")
end


main()