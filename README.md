# pandoc-plantuml-luafilter

Pandoc filter for converting plantuml source into markdown codeblock to image by the plant uml server.

## PlantUML

This filter has depended on plantuml server.
Please use online web (http://www.plantuml.com/plantuml/), or launch locally.
And docker compose configuration file is included into `docker` folder in ihis repository.
Rename configuration file name to `docker-compose.yml` to loaunch a docker image.

### docker compose usage

```
% docker-compose -f docker/docker-compose.yml -d up 
```

### configuration

`config-plantuml.lua.default` file is included into `config` folder in this repository.
This file is settings for PlantUML sever.

* protocol 
    * http or https
* host_name 
    * PlantUML service host name
* port 
    * PlantUML service port number
* format 
    * generated file format
    * supports 'png', 'svg' and 'txt'

### PlantUML codeblock in markdown 

This filter has processed codeblock in markdown file.
codeblock mark `plantuml` class.

snipets:

<pre>
```plantuml
Bob -> Alice : hello
```
</pre>

or

<pre>
```{.plantuml}
Bob -> Alice : hello
```
</pre>

## Usage

```
% pandoc --lua-filter=src/plantuml.lua example/files/example.md --resource-path=example/images
```

## Limitation

## License

This repository is licensed under the zlib license. See LICENSE.txt.
Their original licenses shall be complied when used.
