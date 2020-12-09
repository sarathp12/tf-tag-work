#!/usr/bin/env groovy

@Grab('org.yaml:snakeyaml:1.17')

import org.yaml.snakeyaml.Yaml

Yaml parser = new Yaml()

Map example = parser.load(("test.yaml" as File).text)

println example.pipelineConfig.serviceName

Map valMap = example.pipelineConfig.tagMap

if (valMap != null) {

    varString = "-var pipeline_tags="+((valMap.toMapString()).replace('[', '{').replace(']', '}'))   

    println "Map Name: ${varString}"

    /*

    join ","
    varString = "-var pipeline_tags="+valMap.toMapString()
    println "${varString}"

    toKeyValue = {
        valMap.collectEntries { k,v ->  [k,v] }
    }
    
    
    for ( e in valMap) {
        varString = "-var pipeline_tags="+"{"+"${e.key}=${e.value}"+"}"
        print "${varString}"
    }
    */
    
}

//terraform apply -var 'pipeline_tags={domain="electrode", tier_value="tiera"}'
