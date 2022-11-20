# Marek Traczyński (261748)
# Obliczenia Naukowe
# Lista 2 Zadanie 4


using Polynomials


function main()
    coefficients::Vector{Float64} = [1, 
                               -210.0, 
                               20615.0,
                               -1256850.0,
                               53327946.0,
                               -1672280820.0, 
                               40171771630.0, 
                               -756111184500.0,
                               11310276995381.0, 
                               -135585182899530.0,
                               1307535010540395.0,
                               -10142299865511450.0,
                               63030812099294896.0,
                               -311333643161390640.0,
                               1206647803780373360.0,
                               -3599979517947607200.0,
                               8037811822645051776.0,
                               -12870931245150988800.0,
                               13803759753640704000.0,
                               -8752948036761600000.0,
                               2432902008176640000.0]
    exactroots::Vector{Float64} = [Float64(i) for i in 1:20] 

    wilkinsonnorm::Polynomial{Float64, :x} = Polynomial(reverse(coefficients))
    wilkinsonmult::Polynomial{Float64, :x} = fromroots(exactroots)
    wilkinsonroots::Vector{Float64} = roots(wilkinsonnorm)

    wilkroot::Float64 = zero(Float64)
    absnorm::Float64 = zero(Float64)
    absmult::Float64 = zero(Float64)
    abssub::Float64 = zero(Float64)


    print("\n====================================================\n\n")
    
    println(">>> Wilkinson polynomial test without distortion:") 
    println("|      (z_k, |P(z_k)|, |p(z_k)|, |z_k - k|) ") 
    println("|") 

    for k in 1:20
        wilkroot = wilkinsonroots[k]
        absnorm = abs(wilkinsonnorm(wilkroot))
        absmult = abs(wilkinsonmult(wilkroot))
        abssub = abs(wilkroot - k)

        print("|--> Result for k = $k:\t$wilkroot, $absnorm, $absmult, $abssub\n") 
    end


    print("\n====================================================\n\n")
    

    println(">>> Wilkinson polynomial test with distortion:") 
    println("|      (z_k, |P(z_k)|, |p(z_k)|, |z_k - k|) ") 
    println("|")
    
    coefficients[2] -= 2 ^ (-23)
    
    wilkinsonnorm_distorted::Polynomial{Float64, :x} = Polynomial(reverse(coefficients))
    wilkinsonroots_distorted::Vector{ComplexF64} = roots(wilkinsonnorm_distorted)
    wilkroot_distorted::ComplexF64 = zero(ComplexF64)

    for k in 1:20
        wilkroot_distorted = wilkinsonroots_distorted[k]
        absnorm = abs(wilkinsonnorm_distorted(wilkroot_distorted))
        absmult = abs(wilkinsonmult(wilkroot_distorted))
        abssub = abs(wilkroot_distorted - k)

        print("|--> Result for k = $k:\t$wilkroot_distorted, $absnorm, $absmult, $abssub\n") 
    end
    
    print("\n====================================================\n\n")
end


main()