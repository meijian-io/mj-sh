sh_path=`dirname $0`

yaml_conf=`cat "$sh_path/yaml_conf"`
yamls=`find . -name "application.yaml" -or -name "application.yml"`
for yaml in $yamls:
do
    if [[ ${yaml} == ":" ]];
        then continue
    fi
    
    if [[ ${yaml} == *:* ]];
        then yaml=${yaml%:*};
    fi

    if grep -q "base-path: /mjmonitor" $yaml
    then
        echo "$yaml had be processed"
        continue
    else
        modulePath=${yaml%/src/main*}
        # echo $modulePath
        if [[ -f "$modulePath/pom.xml" ]]; then
                echo "find pom: $modulePath/pom.xml"
                cat $sh_path/yaml_conf >> $yaml
        fi
    fi
done

if [[ $1 == "old" ]]; then
    properties_conf="properties_conf_old"
    properties_key_val="management.context-path"
else
    properties_conf="properties_conf"
    properties_key_val="management.endpoints.web.base-path"
fi
properties=`find . -name "application.properties"`

for property in $properties:
do
    if [[ ${property} == ":" ]];
        then continue
    fi
    
    if [[ ${property} == *:* ]];
        then property=${property%:*};
    fi
    
    if grep -q $properties_key_val $property
    then
        echo "$property had be processed"
        continue
    else
        modulePath=${property%/src/main*}
        # echo $modulePath
        if [[ -f "$modulePath/pom.xml" ]]; then
                echo "find pom: $modulePath/pom.xml"
                cat $sh_path/$properties_conf >> $property
        fi
    fi
done
