package org.harrywang.hadoop.wordcount;

import org.apache.commons.lang3.text.WordUtils;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

import java.io.IOException;

/**
 *
 * @author Rui Wang
 * @version $Id$
 */
public class SumReducer extends Reducer<Text, IntWritable, Text, IntWritable> {

    @Override
    protected void reduce(Text key, Iterable<IntWritable> values, Context context) throws IOException, InterruptedException {
        int wordCount = 0;

        // count the number of words
        for (IntWritable value : values) {
            wordCount += value.get();
        }

        // use external library commons-lang3 to upper case the key
        String upperCaseKey = WordUtils.capitalize(key.toString());

        // output the word and its count
        context.write(new Text(upperCaseKey), new IntWritable(wordCount));
    }
}
