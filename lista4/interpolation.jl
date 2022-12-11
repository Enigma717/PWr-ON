# Marek Traczyński (261748)
# Obliczenia Naukowe
# Lista 4 Zadanie 1, 2, 3, 4


module Interpolation

export ilorazyroznicowe, warnewton, naturalna, rysujnnfx

using Plots


#########################
# Implementacje funkcji #
#########################

#=
Obliczanie ilorazów różnicowych w podanych węzłach

    x = wektor zawierający węzły x_0, ..., x_n    
    f = wektor zawierający wartości funkcji w węzłach x    

=#
function ilorazyroznicowe(x::Vector{Float64}, f::Vector{Float64})
    n::Int = length(x)
    fx::Vector{Float64} = deepcopy(f)

    for i::Int in 2:n
        for j::Int in 1:i-1
            fx[i] = (fx[j] - fx[i]) / (x[j] - x[i])
        end
    end

    return fx
end


#=
Obliczanie wartości wielomianu Newtona dla podanych współczynników

    x  = wektor zawierający w3ęzły x_0, ..., x_n    
    fx = wektor zawieający wartości ilorazów różnicowych dla węzłów x
    t  = punkt, w którym ma zostać obliczona wartość wielomianu

=#
function warnewton(x::Vector{Float64}, fx::Vector{Float64}, t::Float64)
    n::Int = length(x)
    nt::Float64 = fx[n]

    for i::Int in n-1:-1:1
        nt =  fx[i] + (t - x[i]) * nt
    end

    return nt
end


#=
Obliczanie współczynników wielomianu postaci naturalnej z podanego wielomianu Newtona

    x  = wektor zawierający w3ęzły x_0, ..., x_n    
    fx = wektor zawieający wartości ilorazów różnicowych dla węzłów x

=#
function naturalna(x::Vector{Float64}, fx::Vector{Float64})
    n::Int = length(x)
    a::Vector{Float64} = deepcopy(fx)

    for i::Int in n-1:-1:1
        a[i] = fx[i] - x[i] * a[i+1] 
        
        for j::Int in i+1:n-1
            a[j] = a[j] - x[i] * a[j+1]  
        end
    end

    return a
end


#=
Rysowanie interpolacji wielomianowej podanej funkcji na przedziale [a, b]

    f = funkcja, która będzie interpolowana    
    a = lewy koniec przedziału
    b = prawy koniec przedziału
    n = stopień wielomianu interpolacyjnego

=#
function rysujnnfx(f::Function, a::Float64, b::Float64, n::Int, path::String)
    iterations::Int = n + 1
    density::Int = 10
    h::Float64 = zero(Float64)
    currentvalue::Float64 = zero(Float64)

    x::Vector{Float64} = zeros(iterations)
    fx::Vector{Float64} = zeros(iterations)

    differences::Vector{Float64} = zeros(iterations * density)
    interpolationx::Vector{Float64} = zeros(iterations * density)
    interpolationfx::Vector{Float64} = zeros(iterations * density)
    polynomialfx::Vector{Float64} = zeros(iterations * density)

    
    if a > b
        a, b = b, a
    end

    
    h = (b - a) / n

    for k::Int in 1:iterations
        currentvalue = a + (k - 1) * h
        x[k] = currentvalue
        fx[k] = f(x[k])
    end


    iterations *= density
    differences = ilorazyroznicowe(x, fx)
    h = (b - a) / (iterations - 1)

    for k::Int in 1:iterations
        currentvalue = a + (k - 1) * h
        interpolationx[k] = currentvalue
        interpolationfx[k] = warnewton(x, differences, currentvalue) 
        polynomialfx[k] = f(currentvalue)
    end


    interplot = plot(interpolationx,
                     [polynomialfx, interpolationfx],
                     plot_title = "Interpolacja wielomianowa dla n = $n",
                     label = ["Interpolowana funkcja" "Wielomian interpolacyjny"],
                     legend_position = :topleft,
                     linewidth = 3,
                     size = (800, 600),
                     dpi = 300)
                    
    Plots.png(interplot, path)
end


end
