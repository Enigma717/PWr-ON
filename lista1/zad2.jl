# Marek Traczyński (261748)
# Zadanie 2


# Obliczanie wzoru Kahana
function epscalc(type::DataType)
    return type(3) * (type(4)/type(3) - type(1)) - type(1)
end


function main()
    types = [Float16, Float32, Float64]
    
    for type in types
        kahanresult = epscalc(type)
        epsresult = eps(type)

        print("\n================================\n\n")
        println("--> Float type: $type")
        println("|--> Kahan result = $kahanresult")
        println("\\--> Eps() result = $epsresult")
    end

    print("\n================================\n\n")
end


main()