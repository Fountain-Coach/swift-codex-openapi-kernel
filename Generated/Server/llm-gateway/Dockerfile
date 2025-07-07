# llm-gateway server container
FROM swift:6.1-jammy AS build
WORKDIR /src
COPY ./ .
RUN swiftc -O HTTPKernel.swift HTTPRequest.swift HTTPResponse.swift Router.swift Handlers.swift Models.swift main.swift -o /server

FROM ubuntu:22.04
COPY --from=build /server /server
CMD ["/server"]
