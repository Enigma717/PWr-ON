# Marek Traczyński (261748)
# Zadanie 6


# Obliczanie funkcji f(x)
function f(x::Float64)
    return sqrt((x ^ 2) + 1) - 1
end

# Obliczanie funkcji g(x)
function g(x::Float64)
    return (x ^ 2) / (sqrt((x ^ 2) + 1) + 1)
end


function main()
    value::Float64 = one(Float64)

    print("\n==================================\n")

    for i in 1:180
        value /= 8
        println("--> Functions values for 8^-$i")
        println("|--> f(x) = $(f(value))")
        println("\\--> g(x) = $(g(value))")
        print("==================================\n")
    end
end


main()