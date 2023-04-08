FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /src
COPY ["ci-cd-via-githubworkflow.csproj", "ci-cd-via-githubworkflow/"]
RUN dotnet restore "SampleWeb/SampleWeb.csproj"
COPY . .
WORKDIR "/src/ci-cd-via-githubworkflow"
RUN dotnet build "ci-cd-via-githubworkflow.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "ci-cd-via-githubworkflow.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "ci-cd-via-githubworkflow.dll"]