# Marek Traczyński (261748)
# Obliczenia Naukowe
# Lista 2 Zadanie 5


function mandelbrot(n::Integer, x::AbstractFloat, c::AbstractFloat)::Float64
    if n == 0
        return x
    end

    xn::Float64 = mandelbrot(n - 1, x, c)

    return xn ^ 2 + c
end

function main()
    tuples::Vector{Tuple{Float64, Float64}} = [(-2.0, 1.0)
                                               (-2.0, 2.0)
                                               (-2.0, 1.99999999999999)
                                               (-1.0, 1.0)
                                               (-1.0, -1.0)
                                               (-1.0, 0.75)
                                               (-1.0, 0.25)]
    result::Float64 = zero(Float64)
    c::Float64 = zero(Float64)
    x::Float64 = zero(Float64)

    print("\n====================================================\n")

    for tuple in tuples
        c = tuple[1]
        x = tuple[2]
        
        print("\n>>> Test results for (c = $c, x = $x):\n") 
        
        for n in 0:40
            result = mandelbrot(n, x, c)
            
            if mod(n, 5) == 0
                print(" |--> n = $n: $result\n") 
            end
        end
    end

    print("\n====================================================\n\n")
end


main()