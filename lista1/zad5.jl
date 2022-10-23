# Marek Traczyński (261748)
# Zadanie 5


# Obliczanie wektora zawierającego produkt iloczynów skalarnych wektorów x i y
function scalarproduct(x::Vector{}, y::Vector{}, type::DataType)
    n = length(x)
    products = Vector{type}(undef, n)

    for i in 1:n
        products[i] = type(x[i]) * type(y[i])
    end
 
    return products
end

# Obliczanie sumy "w przód"
function uptosum(products::Vector{}, type::DataType)
    sum::type = zero(type)
    n = length(products)

    for i in 1:n
        sum += products[i]
    end

    return sum
end

# Obliczanie sumy "w tył"
function downtosum(products::Vector{}, type::DataType)
    sum::type = zero(type)
    n = length(products)

    for i in n:-1:1
        sum += products[i]
    end

    return sum
end

# Obliczanie sumy od największego do najmniejszego elementu
function largetosmall(products::Vector{}, type::DataType)
    sum1::type = zero(type)
    sum2::type = zero(type)

    productscopy = sort(products, rev = true)
    productscopypos = filter(a -> a > 0, productscopy)
    productscopyneg = filter(a -> a < 0, productscopy)

    sum1 = uptosum(productscopypos, type)
    sum2 = uptosum(productscopyneg, type)

    return sum1 + sum2
end

# Obliczanie sumy od najmniejszego do największego elementu
function smalltolarge(products::Vector{}, type::DataType)
    sum1::type = zero(type)
    sum2::type = zero(type)

    productscopy = sort(products)
    productscopypos = filter(a -> a > 0, productscopy)
    productscopyneg = filter(a -> a < 0, productscopy)

    sum1 = uptosum(productscopypos, type)
    sum2 = uptosum(productscopyneg, type)

    return sum1 + sum2
end

# Obliczanie błędu bezwzględnego
function sumerror(exact, approximated)
    return (abs(approximated - exact) / exact) * 100
end


function main()
    x = [2.718281828, -3.141592654, 1.414213562, 0.5772156649, 0.3010299957]
    y = [1486.2497, 878366.9879, -22.37492, 4773714.647, 0.000185049]
    types = [Float32, Float64]
    exactresult = 1.00657107000000 * 10^(-11)

    for type in types
        products = scalarproduct(x, y, type)
        uptoresult::type = uptosum(products, type)
        downtoresult::type = downtosum(products, type)
        larsmaresult::type = largetosmall(products, type)
        smalarresult::type = smalltolarge(products, type)

        print("\n==========================================\n\n")
        println("--> Used float type: $type")
        println("|--> Up to sum result = $uptoresult   ||   Approximation error = $(sumerror(exactresult, uptoresult))%")
        println("|--> Down to sum result = $downtoresult   ||   Approximation error = $(sumerror(exactresult, downtoresult))%")
        println("|--> Largest to smallest sum result = $larsmaresult   ||   Approximation error = $(sumerror(exactresult, larsmaresult))%")
        println("\\--> Smallest to largest sum result = $smalarresult   ||   Approximation error = $(sumerror(exactresult, smalarresult))%")
    end

    print("\n==========================================\n\n")
end

main()