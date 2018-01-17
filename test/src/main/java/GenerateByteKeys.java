import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Map;
import java.util.TreeMap;

public class GenerateByteKeys {

    private static Map<String,String>  propertiesMap = new TreeMap<>();
    public static void main(String[] args) throws IOException, InterruptedException {
        Path path = Paths.get("/Users/pivotal/workspace/SECRETS");
        File file = path.toFile();
        if(file.exists() && file.isDirectory()){

            File[] files = file.listFiles();
            for (File file1 : files) {
                if (file1.isDirectory()) {
                    String prefixName = file1.getName();
                    System.out.println(prefixName);
                    File[] dirFiles = file1.listFiles();
                    if (prefixName.equalsIgnoreCase("certs")) {

                        for (File dirFile : dirFiles) {

                            if (dirFile.getName().equals("samlKeystore.jks")) {
                                System.out.println("-->" + dirFile.getName());
                                processFile(prefixName, dirFile);
                            }
                        }
                    }else if(prefixName.equalsIgnoreCase("okta")){
                        int count = 1;
                        for (File dirFile : dirFiles) {
                            if (dirFile.getName().endsWith("_sp.xml")) {
                                System.out.println("-->" + dirFile.getName());
                                processFile(prefixName ,"xml-"+count, dirFile);
                                count++;
                            }
                        }
                    }
                    else if (prefixName.equalsIgnoreCase("SFDC-Certs")) {

                        for (File dirFile : dirFiles) {

                            if (dirFile.getName().endsWith(".jks")) {
                                System.out.println("-->" + dirFile.getName());
                                processFile(prefixName, dirFile);
                            }
                        }
                    }
                }

            }

            writeMap();
            printOutPipelineProperties();
        }
    }

    private static void printOutPipelineProperties() {
        for (String key : propertiesMap.keySet()) {
            String dashedSubstituteKey = key.replace("-", "_");
            String upperCaseKey = dashedSubstituteKey.toUpperCase();
            System.out.println(upperCaseKey + ": {{" + key + "}}");
        }
     }

    private static void writeMap() {
        Path path = Paths.get("/Users/pivotal/workspace/concourse-file-test/test/output/creds.yml");

        try(BufferedWriter writer = Files.newBufferedWriter(path)){
            for (Map.Entry<String, String> entry : propertiesMap.entrySet()) {
                String key = entry.getKey();
                String value = entry.getValue();
                writer.write(key);
                writer.write(": ");
                writer.write(value);
                writer.newLine();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        
    }

    private static void processFile(String prefixName, File dirFile) throws IOException, InterruptedException {
        String dirFileName = dirFile.getName();
        String fileName = dirFileName.substring(0, dirFileName.indexOf('.'));
        String variableName = prefixName.toLowerCase() + '-' + fileName.toLowerCase();

        String originalChecksum = getFileChecksum(dirFile);
        
        
        String base64OutputPath = "/Users/pivotal/workspace/concourse-file-test/test/output/" + fileName + ".base64";
        String[] opensslBase64 = {"openssl","base64", "-A", "-in", dirFile.getAbsolutePath(), "-out", base64OutputPath};
        Process p = Runtime.getRuntime().exec(opensslBase64);
        p.waitFor();

        File base64dirFile = new File(base64OutputPath);
        String base64Checksum = getFileChecksum(base64dirFile);

        String base64String =  readBase64File(base64dirFile);
        System.out.println(variableName + "-base64-data: " + base64String);
        System.out.println(variableName + "-original-sha1: " + originalChecksum);
        System.out.println(variableName + "-base64-sha1: " + base64Checksum);

        propertiesMap.put(variableName + "-base64-data",base64String);
        propertiesMap.put(variableName + "-original-sha1",originalChecksum);
        propertiesMap.put(variableName + "-base64-sha1",base64Checksum);
        propertiesMap.put(variableName + "-original-filename", dirFileName);
    }

    private static void processFile(String prefixName, String varname, File dirFile) throws IOException, InterruptedException {
        String dirFileName = dirFile.getName();
        String fileName = dirFileName.substring(0, dirFileName.indexOf('.'));
        String variableName = prefixName.toLowerCase() + '-' + varname;

        String originalChecksum = getFileChecksum(dirFile);


        String base64OutputPath = "/Users/pivotal/workspace/concourse-file-test/test/output/" + fileName + ".base64";
        String[] opensslBase64 = {"openssl","base64", "-A", "-in", dirFile.getAbsolutePath(), "-out", base64OutputPath};
        Process p = Runtime.getRuntime().exec(opensslBase64);
        p.waitFor();

        File base64dirFile = new File(base64OutputPath);
        String base64Checksum = getFileChecksum(base64dirFile);

        String base64String =  readBase64File(base64dirFile);
        System.out.println(variableName + "-base64-data: " + base64String);
        System.out.println(variableName + "-original-sha1: " + originalChecksum);
        System.out.println(variableName + "-base64-sha1: " + base64Checksum);

        propertiesMap.put(variableName + "-base64-data",base64String);
        propertiesMap.put(variableName + "-original-sha1",originalChecksum);
        propertiesMap.put(variableName + "-base64-sha1",base64Checksum);
        propertiesMap.put(variableName + "-original-filename", dirFileName);
    }

    private static String readBase64File(File base64dirFile) throws IOException {
        String content = new String(Files.readAllBytes(Paths.get(base64dirFile.getAbsolutePath())));
        return content;
    }

    private static String getFileChecksum(File dirFile) throws IOException, InterruptedException {
        String[] checksumCommand = {"openssl","dgst", "-sha1", dirFile.getAbsolutePath()};
        Process p = Runtime.getRuntime().exec(checksumCommand);
        p.waitFor();
        BufferedReader reader =
                new BufferedReader(new InputStreamReader(p.getInputStream()));

        String line;
        StringBuilder sb = new StringBuilder();
        while ((line = reader.readLine())!= null) {
            sb.append(line);
        }
        String s = sb.toString();
        return s.substring(s.indexOf("= ") + 2);
    }
}
