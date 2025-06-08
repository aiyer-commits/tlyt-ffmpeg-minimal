# Example Elixir module for using the minimal FFmpeg binary
defmodule TlytPhoenix.FrameExtractor do
  @moduledoc """
  Extract frames from videos using minimal FFmpeg binary
  """
  
  @ffmpeg_path "/app/bin/ffmpeg"  # Path when deployed on Gigalixir
  @local_ffmpeg "./ffmpeg-minimal" # Path for local development
  
  def extract_frame(video_url, timestamp_seconds, output_path) do
    ffmpeg = if File.exists?(@ffmpeg_path), do: @ffmpeg_path, else: @local_ffmpeg
    
    args = [
      "-ss", to_string(timestamp_seconds),
      "-i", video_url,
      "-frames:v", "1",
      "-f", "image2",
      output_path
    ]
    
    System.cmd(ffmpeg, args)
  end
  
  def extract_thumbnail(video_url, timestamp_seconds, output_path, width \\ 320) do
    ffmpeg = if File.exists?(@ffmpeg_path), do: @ffmpeg_path, else: @local_ffmpeg
    height = div(width * 9, 16) # Assume 16:9 aspect ratio
    
    args = [
      "-ss", to_string(timestamp_seconds),
      "-i", video_url,
      "-vf", "scale=#{width}:#{height}",
      "-frames:v", "1",
      "-f", "image2",
      output_path
    ]
    
    System.cmd(ffmpeg, args)
  end
  
  def extract_multiple_frames(video_url, timestamps, output_dir) do
    timestamps
    |> Enum.with_index()
    |> Enum.map(fn {timestamp, index} ->
      output_path = Path.join(output_dir, "frame_#{index}.jpg")
      Task.async(fn ->
        extract_frame(video_url, timestamp, output_path)
      end)
    end)
    |> Task.await_many(30_000) # 30 second timeout
  end
end