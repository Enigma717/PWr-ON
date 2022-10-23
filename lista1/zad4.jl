# Marek Traczyński (261748)
# Zadanie 4


using Distributions


# Obliczanie wzoru x * (1/x)
function evaluation(value::Float64)
    return Float64(value * Float64(1 / value))
end

# Znajdowanie 5 losowych wartości z przedziału [1; 2] spełniających wzór
function findvalue()
    values = Vector{Float64}()

    for i in 1:5
        value::Float64 = rand(Uniform(1,2))
    
        while evaluation(value) == 1
            value = nextfloat(value)
        end

        push!(values, value)
    end

    return values
end

# Znajdowanie najmniejszej wartości z przedziału [1; 2] spełniającej wzór
function findminvalue()
    value::Float64 = one(Float64)

    while evaluation(value) == 1
        value = nextfloat(value)
    end

    return value
end


function main()
    result::Vector{Float64} = findvalue()
    resultmin::Float64 = findminvalue()

    print("\n================================\n\n")
    println("Some values found in [1;2] = $result")
    println("Minimum value found in [1;2] = $resultmin")
    print("\n================================\n\n")
end

main()