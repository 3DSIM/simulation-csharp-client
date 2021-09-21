FROM mcr.microsoft.com/dotnet/sdk:5.0

ENV PACKAGE=SimulationCSharpClient
COPY . /tmp
WORKDIR /tmp
ARG VERSION

# Run unit tests and build nuget package
RUN ./build.sh --test --pkg-dir=/tmp/package

# Publish
RUN curl -X POST "https://www.myget.org/F/3dsim-utility/api/v2/package" -H "X-NuGet-ApiKey: 14dd5115-5433-4da8-b8a3-69fe02cf49cf" -T /tmp/package/${PACKAGE}.${VERSION}.nupkg
