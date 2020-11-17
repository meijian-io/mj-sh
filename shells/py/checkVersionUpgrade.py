# -*- coding: utf-8 -*-

from xml.dom.minidom import parse
import xml.dom.minidom
import requests
import os
import re
import numpy as np
import sys


# 配置项字典
propertiesDict = {}


def find_pom(file_dir):
    """1、获取指定目录下的所有pom文件路径

    :param file_dir: 指定目录
    :return: 目录下的所有pom.xml文件
    """
    # file_dir = "/Users/meijian-wyl/work/serverProjects/meijian-pay"
    output = os.popen('find ' + file_dir + ' -name "pom.xml"')
    outArray = []
    for pomFile in output.readlines():
        outArray.append(pomFile.replace("\n", ""))
    return outArray


def check_version(pom_list, type):
    """2、检测版本号

    :param pom_list: 文件
    :param type: snapshot-快照，release-正式，all-所有
    :return: 无返回
    """
    hasSnap = False
    for pomFile in pom_list:
        hasSnap = has_snapshot(pomFile)
        if hasSnap:
            break

    moduleArray = []
    for pomFile in pom_list:
        dep = get_module(pomFile, type)
        moduleArray = moduleArray + dep
    mList = array_rm(moduleArray)
    print("——————————————%s version [%s]，其中【%s】快照包——————————————" % (type, len(mList), "_有_" if hasSnap else "没有"))
    print("私服最高版本--\t--groupId--\t--artifactId--\t--version--\t--pom--")
    for one in mList:
        lastVersion = get_last_release_version(one[0], one[1])
        if lastVersion is None:
            print 'noRelease\t%s' % '\t'.join(one)
        if lastVersion is not None and lastVersion[2] != one[2]:
            print '%s\t%s' % (lastVersion[2], '\t'.join(one))


def has_snapshot(file_path):
    """文件中是否包含snapshot

    :param file_path: 文件全路径
    :return: True：包含；False：不包含
    """
    # file_path = "/Users/meijian-wyl/work/serverProjects/meijian-pay/pom.xml"
    find_str = "-SNAPSHOT"
    p = "<.*>.*%s</.*>" % find_str
    if re.search(p, file(file_path).read()):
        return True
    else:
        return False


def get_module(pom_file, type):
    """
    2.1、获取pom文件中的所有jar与版本号

    :param pom_file: 文件全路径
    :param type: snapshot-取快照包, release-取正式包, all-取所有"com.meijian"
    :return: [[groupId, artifactId, version]]
    """
    pfa = pom_file.split('/')
    pom_lp = "%s/%s/%s" % (pfa[len(pfa) - 3], pfa[len(pfa) - 2], pfa[len(pfa) - 1])

    doc = xml.dom.minidom.parse(pom_file)
    pomRoot = doc.documentElement

    get_properties(pomRoot)

    depManage = pomRoot.getElementsByTagName("dependencyManagement")
    if depManage.length > 0:
        return get_module_array_from_dom(depManage[0], type, pom_lp, propertiesDict)
    else:
        return get_module_array_from_dom(pomRoot, type, pom_lp, propertiesDict)


def get_properties(pomRoot):
    """
    2.1.1、获取pom中的所有properties放入字典中
    :param pomRoot: pom内容
    :return: 无
    """
    prps = pomRoot.getElementsByTagName("properties")
    if prps.length > 0:
        for prp in prps[0].childNodes:
            if prp.nodeType == 1:
                prpKey = prp.nodeName.encode("utf-8")
                prpValue = prp.childNodes[0].nodeValue.encode("utf-8")
                propertiesDict[prpKey] = prpValue
        # print propertiesDict.keys()
        # print propertiesDict.values()


def get_module_array_from_dom(pomRoot, type, pom_lp, propretiesDic):
    outArray = []
    deps = pomRoot.getElementsByTagName("dependencies")
    if deps.length > 0:
        for dep in deps[0].childNodes:
            if dep.nodeType == 1:
                groupId = dep.getElementsByTagName("groupId")[0].childNodes[0].nodeValue.encode("utf-8")
                artifactId = dep.getElementsByTagName("artifactId")[0].childNodes[0].nodeValue.encode("utf-8")
                if dep.getElementsByTagName("version").length > 0:
                    version = dep.getElementsByTagName("version")[0].childNodes[0].nodeValue.encode("utf-8")
                    oldVersion = ""
                    if "$" in version and propretiesDic.has_key(version[2:-1]):
                        oldVersion = version
                        version = propretiesDic[version[2:-1]]
                    if type == "snapshot" and "SNAPSHOT" in version:
                        outArray.append([groupId, artifactId, version, pom_lp, oldVersion])
                    if type == "release" and "RELEASE" in version and version != "1.0" \
                            and "meijian" in groupId \
                            and "biz-service" not in artifactId \
                            and "-core" not in artifactId and "-impl" not in artifactId:
                        outArray.append([groupId, artifactId, version, pom_lp, oldVersion])
                    if type == "all" and version != "1.0" \
                            and "meijian" in groupId \
                            and "biz-service" not in artifactId \
                            and "-core" not in artifactId and "-impl" not in artifactId:
                        outArray.append([groupId, artifactId, version, pom_lp, oldVersion])
                    if type == "other" and "SNAPSHOT" not in version and "RELEASE" not in version and version != "1.0" \
                            and "meijian" in groupId \
                            and "biz-service" not in artifactId \
                            and "-core" not in artifactId and "-impl" not in artifactId:
                        outArray.append([groupId, artifactId, version, pom_lp, oldVersion])
                else:
                    if type == "none" \
                            and "meijian" in groupId \
                            and "biz-service" not in artifactId \
                            and "-core" not in artifactId and "-impl" not in artifactId:
                        outArray.append([groupId, artifactId, "parentVersion", pom_lp])
    return outArray


def array_rm(two_array):
    """2.2、二维数组去重

    :param two_array: 目标数组
    :return: 去重后的数组
    """
    # 方法一：利用set,set是无序不重复集合(推荐)
    s = set()  # 创建空集合
    for t in two_array:
        s.add(tuple(t))  # 将数组转为元祖tuple，保证不被修改；再把元祖加入到集合中，完成去重
    g = np.array(list(s))  # 将集合转换为列表，最后转为二维数组
    # print(g)
    return g


def get_last_release_version(group_id, artifact_id):
    """2.3、获取私服中的最高版本

    :param group_id: eg: com.meijian.base
    :param artifact_id: eg: base-module
    :return: [group_id, artifact_id, lastVersion] 或 None
    """
    groupPath = group_id.replace(".", "/")
    url = "http://192.168.1.75:8081/nexus/content/repositories/releases/" \
          + groupPath + "/" + artifact_id + "/maven-metadata.xml"
    response = requests.request("GET", url)
    if response.status_code == 200:
        versionPomRoot = xml.dom.minidom.parseString(response.content)
        metadata = versionPomRoot.documentElement
        vers = metadata.getElementsByTagName("versioning")
        lastVaersion = vers[0].getElementsByTagName("release")[0].childNodes[0].nodeValue.encode("utf-8")
        return [group_id, artifact_id, lastVaersion]
        # for line in metadata.childNodes:
        #     # if "groupId" == line.nodeName:
        #     #     print line.childNodes[0].nodeValue
        #     # if "artifactId" == line.nodeName:
        #     #     print line.childNodes[0].nodeValue
        #     if 'versioning' == line.nodeName:
        #         # print line.childNodes[1].childNodes[0].nodeValue
        #         return [group_id, artifact_id, line.childNodes[1].childNodes[0].nodeValue.encode("utf-8")]
    else:
        return None


# xxx.py {checkType} {projectPath}
if __name__ == "__main__":
    # projectPath = "/Users/meijian-wyl/work/serverProjects"
    projectPath = sys.argv[2]
    pomList = find_pom(projectPath)
    print("---->>[%s]======>>总计[%s]个pom文件" % (projectPath, len(pomList)))
    check_version(pomList, sys.argv[1])
    # if sys.argv[1] == "snapshot":
    #     check_version(pomList, sys.argv[1])
    # elif sys.argv[1] == "release":
    #     check_version(pomList, sys.argv[1])
    # elif sys.argv[1] == "all":
    #     check_version(pomList, sys.argv[1])
