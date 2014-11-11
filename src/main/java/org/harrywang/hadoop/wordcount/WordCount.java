package org.harrywang.hadoop.wordcount;

import org.apache.hadoop.conf.Configured;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.util.Tool;
import org.apache.hadoop.util.ToolRunner;

/**
 * Hadoop job for doing word count
 *
 * @author Rui Wang
 * @version $Id$
 */
public class WordCount extends Configured implements Tool{

    @Override
    public int run(String[] args) throws Exception {
        if (args.length != 2) {
            System.err.printf("Usage %s [generic options] <input> <output>\n", getClass().getSimpleName());
            ToolRunner.printGenericCommandUsage(System.err);
            return -1;
        }

        // setup a hadoop job and reuse the existing configurations
        Job job = new Job(getConf());
        job.setJarByClass(WordCount.class);
        job.setJobName("Word Count");

        // setup input and output path
        FileInputFormat.setInputPaths(job, new Path(args[0]));
        FileOutputFormat.setOutputPath(job, new Path(args[1]));

        // add mapper and reducer
        job.setMapperClass(WordMapper.class);
        job.setReducerClass(SumReducer.class);

        // set the output format
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(IntWritable.class);

        // check the status of the job
        boolean success = job.waitForCompletion(true);
        return success ? 0 : 1;
    }

    public static void main(String[] args) throws Exception {
        int exitCode = ToolRunner.run(new WordCount(), args);
        System.exit(exitCode);
    }
}
