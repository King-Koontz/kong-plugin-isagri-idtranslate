local cjson = require "cjson"
local http = require("socket.http")

local _M = {}


function _M.execute(conf)

  --Lecture du DomainId dans le Header
  local domainID = kong.request.get_header("domainID") 
  kong.log.debug("header: domainID = ", domainID)

  --Récupération du path, pour ensuite pouvoir récupérer les information contenues dedans
  local path = kong.request.get_path()
  kong.log.debug("path: ", path)

  --Récupération de la version d'API demandée
  local vers = path:match("/V%d/") 
  apiVersion = string.sub(vers, 2, -2)
  kong.log.debug("vers: ", vers)
  kong.log.debug("path vers: ", apiVersion)
  
  --Par défaut, la version sera la V1
  if apiVersion == nil then
    apiVersion = "V1"
  end

  --interrogation de l'IS-AD pour récupérer la liste des service applicatif supportant la version d'API demandée
  local requestString = "http://isagritestsd.azure-api.net/is-ad/versions?apiVersion="..apiVersion.."&domainID="..domainID
  kong.log.debug("requete: ", requestString)
  
  local body, code = http.request(requestString)
  local jsonDict = cjson.decode(body)

  local messageISAD = jsonDict.message
  kong.log.debug("json result: ", body)
  kong.log.debug("json message: ", messageISAD)

  local versiontoget = ""

  local i=0
  local t={}
  local index=0

  --Path = /api/GC/V1/factures
  --Split du path dans un tableau. le 1er indice contiendra 'api', le second, le code produit, le 3ème la version de l'api, et le reste, le nom du service à cibler
  for token in string.gmatch(path, "[^/]+") do
    t[i] = token
    i = i + 1
  end

  for index = 0, i do
    kong.log.debug("path: ", index, " : ", t[index])
  end

  --Récupération du produit, et du nom de service applicatif à cibler (incluant éventuellement un domaine focntionnel)
  index = 0;
  while t[index] ~= "api" and index<i do
    index = index + 1
  end

  local produit = nil
  local service = ""

  if index <i then
    produit = t[index+1]
    
    index = index+2
    while t[index] ~= apiVersion and index<i do
      index = index + 1
    end

    if index <i then
      for x=index+1, i do
          if t[x] ~=nil then
            service = service.."/" ..t[x]
          end
      end
    end
  end

  kong.log.debug("produit: ", produit)
  kong.log.debug("service: ", service)


  --Interrogation de toutes les versions de services renvoyées par l'IS-AD, afin de savoir s'ils supportent le domainID demandé
  for token in string.gmatch(messageISAD, "[^,]+") do
    kong.log.debug("message V: ", token)

    requestString = "http://isagritestsd.azure-api.net/"..produit.."/"..token.."/state?domainID="..domainID
    kong.log.debug("requete state : ", requestString)
    
    local body, code = http.request(requestString)
    local jsonDict = cjson.decode(body)

    local messageState = jsonDict.message
    kong.log.debug("json result: ", body)
    kong.log.debug("json message: ", messageState) 
    
    if messageState=="OK" then
      kong.log.debug("message ok")
      versiontoget = token -- Stockage de la version du service applicatif à cibler
    else
      kong.log.debug("message nok")
    end

    kong.log.debug("json versionToGet: ", versiontoget)
  end

  kong.log.debug("json versionToGet: ", versiontoget)
  kong.log.debug("json servicePath: ", "/"..produit.."/"..versiontoget..service)

  --Affectation du path à cibler en fonction du code produit et de la version applicative à cibler
  --rq: Le serveur de requêtes est déjà ciblé par la config Kong
  kong.service.request.set_path("/"..produit.."/"..versiontoget..service)
  kong.service.request.set_raw_query("apiVersion="..apiVersion)
end

return _M
