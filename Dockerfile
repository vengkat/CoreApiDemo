# Stage 1
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /src
COPY ["CoreApiDemo.csproj","CoreApiDemo/"]
RUN dotnet restore "CoreApiDemo/CoreApiDemo.csproj"
WORKDIR "/src/CoreApiDemo"
COPY . .
RUN dotnet build "CoreApiDemo.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "CoreApiDemo.csproj" -c Release -o /app/publish


FROM base as final
WORKDIR /app
COPY --from=publish  /app/publish .
ENTRYPOINT ["dotnet", "CoreApiDemo.dll"]
