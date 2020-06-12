# -*- coding: utf-8 -*-

from xml.dom.minidom import parse
import xml.dom.minidom
import requests
import os
import re
import numpy as np
import sys


def get_last_release_version(group_id, artifact_id):
    """获取私服中的最高版本

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


def find_pom(file_dir):
    """获取指定目录下的所有pom文件路径

    :param file_dir: 指定目录
    :return: 目录下的所有pom.xml文件
    """
    # file_dir = "/Users/meijian-wyl/work/serverProjects/meijian-pay"
    output = os.popen('find ' + file_dir + ' -name "pom.xml"')
    outArray = []
    for pomFile in output.readlines():
        outArray.append(pomFile.replace("\n", ""))
    return outArray


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


def get_module(pom_file, only_snapshot):
    """
    获取所有版本号

    :param pom_file: 文件全路径
    :param only_snapshot: True-只取快照，False-取所有"com.meijian"
    :return: [[groupId, artifactId, version]]
    """
    pfa = pom_file.split('/')
    pom_lp = "%s/%s/%s" % (pfa[len(pfa) - 3], pfa[len(pfa) - 2], pfa[len(pfa) - 1])
    outArray = []
    doc = xml.dom.minidom.parse(pom_file)
    pomRoot = doc.documentElement
    deps = pomRoot.getElementsByTagName("dependencies")
    if deps.length > 0:
        for dep in deps[0].childNodes:
            if dep.nodeType == 1:
                groupId = dep.getElementsByTagName("groupId")[0].childNodes[0].nodeValue.encode("utf-8")
                artifactId = dep.getElementsByTagName("artifactId")[0].childNodes[0].nodeValue.encode("utf-8")
                if dep.getElementsByTagName("version").length > 0:
                    version = dep.getElementsByTagName("version")[0].childNodes[0].nodeValue.encode("utf-8")
                    if only_snapshot and "SNAPSHOT" in version:
                        outArray.append([groupId, artifactId, version, pom_lp])
                    if bool(1 - only_snapshot) and "meijian" in groupId \
                            and version != "1.0" \
                            and "biz-service" not in artifactId \
                            and "-core" not in artifactId \
                            and "-impl" not in artifactId:
                        outArray.append([groupId, artifactId, version, pom_lp])
    return outArray


def array_rm(two_array):
    """二维数组去重

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


def check_snapshot_version(pom_list):
    moduleArray = []
    for pomFile in pom_list:
        hs = has_snapshot(pomFile)
        # print(str(hs) + "  " + f)
        if hs:
            dep = get_module(pomFile, True)
            moduleArray = moduleArray + dep
    # print outArray
    mList = array_rm(moduleArray)
    print("——————————————SNAPSHOT version [%s]——————————————" % len(mList))
    print("私服最高版本--\t--groupId--\t--artifactId--\t--version--\t--pom--")
    for one in mList:
        lastVersion = get_last_release_version(one[0], one[1])
        if lastVersion is None:
            print 'noRelease\t%s' % '\t'.join(one)
        if lastVersion is not None and lastVersion[2] != one[2]:
            print '%s\t%s' % (lastVersion[2], '\t'.join(one))


def check_all_version(pom_list):
    moduleArray = []
    for pomFile in pom_list:
        dep = get_module(pomFile, False)
        moduleArray = moduleArray + dep
    # print outArray
    mList = array_rm(moduleArray)
    print("——————————————all version [%s]——————————————" % len(mList))
    print("私服最高版本--\t--groupId--\t--artifactId--\t--version--\t--pom--")
    for one in mList:
        if "SNAPSHOT" not in one[2]:
            lastVersion = get_last_release_version(one[0], one[1])
            if lastVersion is None:
                print 'noRelease\t%s' % '\t'.join(one)
            if lastVersion is not None and lastVersion[2] != one[2]:
                print '%s\t%s' % (lastVersion[2], '\t'.join(one))


# xxx.py {isSnapshot} {projectPath}
if __name__ == "__main__":
#     projectPath = "/Users/meijian-wyl/work/serverProjects"
    projectPath = sys.argv[2]
    pomList = find_pom(projectPath)
    print("%s ======>>总计[%s]个pom文件" % (projectPath, len(pomList)))
    if sys.argv[1] == "snapshot":
        check_snapshot_version(pomList)
    else:
        check_all_version(pomList)