# Marek Traczyński (261748)
# Zadanie 7


# Obliczanie funkcji f(x)
function f(x::Float64)
    return sin(x) + cos(3 * x)
end

# Obliczanie pochodnej funkcji f(x)
function fderivative(x::Float64)
    return cos(x) - 3 * sin(3 * x)
end

# Obliczanie przybliżenia pochodnej funkcji f(x) ze wzoru (f(x + h) - f(x)) / h
function ftilde(x::Float64, h::Float64)
    return (f(x + h) - f(x)) / h
end

# Obliczanie błędu względnego
function ferror(x::Float64, h::Float64)
    return abs(fderivative(x) - ftilde(x, h))
end


function main()
    x::Float64 = one(Float64)
    
    print("\n======================================\n\n")
    println("--> Derivative value = $(fderivative(x))")
    print("\n======================================\n\n")
    
    for n in 0:54
        h::Float64 = 2.0 ^ (-n)

        println("--> H value = $h (2^-$n)")
        println("|--> Approximated derivative value = $(ftilde(x, h))")
        println("\\--> Absolute error value = $(ferror(x, h))")
        print("\n======================================\n\n")
    end
end

main()