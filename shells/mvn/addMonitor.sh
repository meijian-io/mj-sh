#!/usr/bin/env bash
sh_path=`dirname $0`
workDir=$(pwd)

filePath=

check_version() {
#    echo ${filePath}
    if [[ ${filePath} =~ "/mj-server/" || ${filePath} =~ "/meijian-push/" ]]; then
        if [[ ${filePath} =~ .properties$ ]]; then
            properties_conf="properties_conf_old"
            properties_key_val="management.context-path"
        else
            properties_conf="yaml_conf_old"
            properties_key_val="path: /health"
        fi
    else
        if [[ ${filePath} =~ .properties$ ]]; then
            properties_conf="properties_conf"
            properties_key_val="management.endpoints.web.base-path"
        else
            properties_conf="yaml_conf"
            properties_key_val="base-path: /mjmonitor"
        fi
    fi
}

add_proper() {
    properties=`find . -name "application.yaml" -or -name "application.yml" -or  -name "application.properties"`

    for property in ${properties}; do
        if [[ ${property} == ":" ]]; then
            continue
        fi

        if [[ ${property} == *:* ]]; then
            property=${property%:*};
        fi

        filePath=${workDir}/${property}
        check_version

        modulePath=${property%/src/main*}
        if [[ -f "${modulePath}/pom.xml" ]]; then
#            echo "find pom: ${modulePath}/pom.xml"

#            hadPro=$(grep "${properties_key_val}" ${property})
#            if [[ ${hadPro} == "" ]]; then
#                cat ${sh_path}/${properties_conf} >> ${property}
#            fi
            hadPom=$(grep "spring-boot-starter-actuator" ${modulePath}/pom.xml)
            if [[ ${hadPom} == "" ]]; then
                echo "no spring-boot-starter-actuator: ${modulePath}/pom.xml"
            fi
            hadWeb=$(grep "spring-boot-starter-web" ${modulePath}/pom.xml)
            if [[ ${hadWeb} == "" ]]; then
                echo "no spring-boot-starter-web: ${modulePath}/pom.xml"
            fi
        fi
    done
}

add_proper

