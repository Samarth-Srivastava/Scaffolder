#! /bin/bash
cd /e/Projects/
prjtype="console"
echo "Project Type: (Enter a number)"
echo "1: Console App"
echo "2: Class Library"
echo "3: Web Api"
echo "4: MVC Web App"
echo "5: Razor Web App"
read inptprjtype
read -p "Project Name: " slnname
prjname=$slnname.console
case "$inptprjtype" in
   "1") 
   ;;
   "2") prjtype="classlib"
		prjname=$slnname.lib
   ;;
   "3") prjtype="webapi"
		prjname=$slnname.webapi
   ;;
   "4") prjtype="webapp"
		prjname=$slnname.mvc
   ;;
   "5") prjtype="razor"
		prjname=$slnname.razor
   ;;
   *) echo -n "Not a project type. Exiting..."
		sleep 3s
		exit 0
	;;
esac
mkdir $slnname
cd $slnname
dotnet new sln -n $slnname
dotnet new $prjtype -o $prjname
dotnet sln $slnname.sln add ./$prjname/$prjname.csproj
if [ "$inptprjtype" -eq "1" ];
then
	cd $prjname
	echo -e "//driver code\r\nusing System;\r\nusing System.IO;\r\n\r\nnamespace $prjname{\r\n\tpublic class Program{\r\n\t\tpublic static void Main(string[] args){\r\n\t\t\tSolution s = new Solution();\r\n\r\n\t\t\ts.solve();\r\n\t\t}\r\n\t}\r\n}" > Program.cs
	echo -e "namespace $prjname{\r\n\tpublic class Solution{\r\n\t\tpublic void solve(){\r\n\r\n\t\t}\r\n\t}\r\n}">src.cs
	cd ..
elif [ "$inptprjtype" -eq "3" ]
then
	dotnet new classlib -o Application
	dotnet new classlib -o Application.Contract
	dotnet sln $slnname.sln add ./Application/Application.csproj
	dotnet sln $slnname.sln add ./Application.Contract/Application.Contract.csproj
	dotnet add ./Application/Application.csproj reference ./Application.Contract/Application.Contract.csproj
	dotnet add ./$prjname/$prjname.csproj reference ./Application.Contract/Application.Contract.csproj
	dotnet add ./$prjname/$prjname.csproj reference ./Application/Application.csproj
	cd Application.Contract
	rm Class1.cs
	echo -e "using System;\r\n\r\nnamespace $slnname.Application.Contract{\r\n\tpublic interface IApplication{\r\n\t\tpublic void solve();\r\n\t}\r\n}" > IApplication.cs
	cd ../Application
	rm Class1.cs
	echo -e "using System;\r\nusing $slnname.Application.Contract;\r\n\r\nnamespace $slnname.Application{\r\n\tpublic class MyApplication : IApplication{\r\n\t\tpublic void solve(){}\r\n\t}\r\n}" > Application.cs
	cd ../$prjname
	echo -e "using $slnname.Application;\r\nusing $slnname.Application.Contract;\r\n\r\nnamespace $prjname{\r\n\tpublic static class CustomServices{\r\n\t\tpublic static IServiceCollection AddCustomServices(this IServiceCollection services){\r\n\r\n\t\t\tservices.AddScoped<IApplication, MyApplication>();\r\n\r\n\t\t\treturn services;\r\n\t\t}\r\n\t}\r\n}" > CustomServices.cs
	sed -i "1 i using $prjname;" Program.cs
	sed -i '10 i builder.Services.AddCustomServices();' Program.cs
	cd ..
else
	echo -n "else"
fi
# dotnet new xunit -o $slnname.Tests
# dotnet sln $slnname.sln add ./$slnname.Tests/$slnname.Tests.csproj
# dotnet add ./$slnname.Tests/$slnname.Tests.csproj reference ./$slnname/Application.csproj
code .
