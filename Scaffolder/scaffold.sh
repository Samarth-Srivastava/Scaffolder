#! /bin/bash
prjtype="console"
echo "Project Type: (Enter a number)"
echo "1: Console App"
echo "2: Class Library"
echo "3: Web Api"
echo "4: MVC Web App"
echo "5: Razor Web App"
read inptprjtype
case "$inptprjtype" in
   "1") prjtype="console"
   ;;
   "2") prjtype="classlib"
   ;;
   "3") prjtype="webapi"
   ;;
   "4") prjtype="webapp"
   ;;
   "5") prjtype="razor"
   ;;
   *) echo -n "Not a project type. Exiting..."
		sleep 3s
		exit 0
	;;
esac
read -p "Project Name: " prjname
mkdir $prjname
cd $prjname
dotnet new sln -n $prjname
dotnet new $prjtype -o $prjname
dotnet sln $prjname.sln add ./$prjname/$prjname.csproj
cd $prjname
echo -e "//driver code\r\nusing System;\r\nusing System.IO;\r\n\r\nnamespace $prjname{\r\n\tpublic class Program{\r\n\t\tpublic static void Main(string[] args){\r\n\t\t\tSolution s = new Solution();\r\n\r\n\t\t\ts.solve();\r\n\t\t}\r\n\t}\r\n}" > Program.cs
echo -e "namespace $prjname{\r\n\tpublic class Solution{\r\n\t\tpublic void solve(){\r\n\r\n\t\t}\r\n\t}\r\n}">src.cs
exit 0