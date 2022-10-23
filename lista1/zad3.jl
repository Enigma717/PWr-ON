# Marek Traczyński (261748)
# Zadanie 3


using Distributions


function main()
    for i in 3:-1:1
        x = 4 / (2^i)
        y = 8 / (2^i)

        myfloat::Float64 = rand(Uniform(x,y))
        next::Float64 = nextfloat(myfloat)

        print("\n==================================\n\n")
        println(">>> 10 next values from [$x; $y]") 
        println("|")

        for j in 1:10
            next = nextfloat(next)
            println("|--> $(bitstring(next))")
        end
    end

    print("\n==================================\n\n")
end


main()