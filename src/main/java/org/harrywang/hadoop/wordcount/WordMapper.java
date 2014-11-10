package org.harrywang.hadoop.wordcount;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

import java.io.IOException;

/**
 * Simple word count mapper
 *
 * @author Rui Wang
 * @version $Id$
 */
public class WordMapper extends Mapper<LongWritable, Text, Text, IntWritable> {

    @Override
    protected void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {

        // convert the line received as Text object to a String object
        String line = value.toString();

        // split the line into words
        for (String word : line.split("\\W+")) {
            if (word.length() > 0) {
                // write out the word and count 1
                context.write(new Text(word), new IntWritable(1));
            }
        }
    }
}
