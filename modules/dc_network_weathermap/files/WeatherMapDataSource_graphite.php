<?php
// Datasource for Graphite (http://graphite.wikidot.com/)
// Quick and dirty script based on https://github.com/alexforrow/php-weathermap-graphite
// Arzhel Younsi

// TARGET graphite:(graphite_server)|in|(out)|(type)
//      e.g. graphite:graphite.example.net:82|network.net1.router1_example_net.int.xe_0_0_2.outbytes|network.net1.router1_example_net.int.xe_0_0_2.inbytes|interface
//
//  host - graphite server to use, if empty it will use the value define below to keep the weathermap conf clean
//  in   - string of the ressource to graph
//  out  - (optionnal) string of the ressource to graph for the other direction
//  type - (optionnal) if set to "interface" will add "scale(scaleToSeconds(nonNegativeDerivative($targetIn),1),8)"
//         to get the numbers as bytes per seconds. (Doesn't work yet if the counter wraps)
//         You can also add the operators directly to the in or out value.
//
class WeatherMapDataSource_graphite extends WeatherMapDataSource {

    private $regex_pattern = "/^graphite:([^|]*)|([^|]+)|([^|]*)|([^|]*)$/";

    function Init(&$map)
    {
        if(function_exists('curl_init')) { return(TRUE); }
        print("GRAPHITE DS: curl_init() not found. Do you have the PHP CURL module?\n");

        return(FALSE);
    }

    function Recognise($targetstring)
    {
        if(preg_match($this->regex_pattern, $targetstring, $matches))
        {
            return TRUE;
        }
        else
        {
            return FALSE;
        }
    }

    function HTTPRequest($host,$keys){
        $request ="";
        foreach($keys as $key) $request = $request . "&target=$key";

        // make HTTP request
        $url = "http://$host/render?format=raw&from=-3minutes$request";
        //print("GRAPHITE DS: Connecting to $url");
        $ch = curl_init($url);
        curl_setopt_array($ch, array(
                    CURLOPT_RETURNTRANSFER => true,
                    CURLOPT_TIMEOUT => 3,
                    ));
        $data = curl_exec($ch);
        $status = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        if ($status != 200) {
            print("GRAPHITE DS: Got HTTP code $status from Graphite for $url");
            return;
        }
        return $data;

    }

    function RawGraphiteToSingle($data){
        $lines = explode("\n",$data,-1);
        $valuesLines = array();
        foreach($lines as $line){ 
            # Data in form: devices.servers.XXXXXXX.software.items.read.roc,1331035560,1331035740,60|3037.56666667,2995.4,None
            list($meta, $values) = explode('|', $line, 2);
            $values = explode(',', trim($values));
            # get most recent value that is not 'None'
            while(count($values) > 0) {
                $value = array_pop($values);
                if ($value !== 'None') {
                    break;
                }
            }

            if ($value === 'None') {
                // no value found
                print("GRAPHITE DS: No valid data points found");
                return;
            }
           array_push($valuesLines,$value);
        }
        return $valuesLines;

    }

    function ReadData($targetstring, &$map, &$item)
    {
        $graphite="graphite:";
        if(!strncmp($targetstring, $graphite, strlen($graphite))){
            $targetstring = substr($targetstring,strlen($graphite));
        }
        else
        {
            print("GRAPHITE DS: TARGET doesn't start by graphite:");
            return;
        }
        $keys=array();
        list($host,$targetIn,$targetOut,$type) = array_pad(explode('|', $targetstring), 4, "");
            if($host == "") $host="myhost:82";

        if($targetOut=="") $targetOut=$targetIn;
        if($type=="interface"){
            $targetIn="scale(scaleToSeconds(nonNegativeDerivative($targetIn),1),8)";
            $targetOut="scale(scaleToSeconds(nonNregativeDerivative($targetOut),1),8)";
        }
        $keys[0] = $targetIn;
        $keys[1] = $targetOut;
        $data = WeatherMapDataSource_graphite::HTTPRequest($host,$keys);
        $values = WeatherMapDataSource_graphite::RawGraphiteToSingle($data);
        // array(in,out,time)		


        return array($values[0], $values[1], time());
    }

}

// vim:ts=4:sw=4:
?>
