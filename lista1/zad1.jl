# Marek Traczyński (261748)
# Zadanie 1

# Obliczanie epsilona maszynowego
function machineeps(type::DataType)
    epsilon::type = one(type)
    prevepsilon::type = epsilon
    floatone::type = one(type)

    while floatone + epsilon != floatone
        prevepsilon = epsilon
        epsilon /= type(2)
    end

    return prevepsilon
end

# Obliczanie liczby maszynowej eta
function machineeta(type::DataType)
    eta::type = one(type)
    preveta::type = eta
    floatzero::type = zero(type)

    while eta != floatzero
        preveta = eta
        eta /= type(2)
    end

    return preveta
end

# Obliczanie liczby MAX
function findmaxfloat(type::DataType)
    max::type = one(type)
    correction::type = zero(type)

    while isinf(max * type(2)) == false
        max *= type(2)
    end

    correction = max

    while correction / type(2) != 0
        if isinf(max + correction) == false
            max += correction
        end
            
        correction /= type(2)
    end

    return max + ((correction / type(2)) - 1)
end


function main()
    types = [Float16, Float32, Float64]
    
    for type in types
        epsilon::type = machineeps(type)
        eta::type = machineeta(type)
        mymaxfloat::type = findmaxfloat(type)
        funceps::type = eps(type)


        print("\n================================\n\n")
        println(">>> Used type: $type")
        println("|--> Calculated epsilon = $epsilon")
        println("|--> Eps() result = $funceps")
        println("|")
        println("|--> Calculated eta =  $eta")
        println("|--> Nextfloat() result = $(nextfloat(zero(type)))")
        println("|")
        println("|--> Calculated maximum float =  $mymaxfloat")
        println("|--> Floatmax() result = $(floatmax(type))")
    end

    print("\n================================\n\n")
end


main()