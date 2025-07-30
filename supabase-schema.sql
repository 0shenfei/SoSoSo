-- 社交媒体日历数据库结构

-- 启用Row Level Security
ALTER DATABASE postgres SET "app.jwt_secret" TO 'your-jwt-secret';

-- 用户表（扩展内置auth.users）
CREATE TABLE public.user_profiles (
  id UUID REFERENCES auth.users(id) PRIMARY KEY,
  email TEXT,
  display_name TEXT,
  avatar_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 发布内容表
CREATE TABLE public.posts (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  date DATE NOT NULL,
  caption TEXT,
  platforms TEXT[] DEFAULT '{}',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 媒体文件表
CREATE TABLE public.media_files (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  post_id UUID REFERENCES public.posts(id) ON DELETE CASCADE,
  file_name TEXT NOT NULL,
  file_type TEXT NOT NULL CHECK (file_type IN ('image', 'video')),
  file_url TEXT NOT NULL,
  thumbnail_url TEXT,
  compressed_url TEXT,
  file_size INTEGER,
  original_name TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 创建索引提高查询性能
CREATE INDEX idx_posts_user_date ON public.posts(user_id, date);
CREATE INDEX idx_posts_date ON public.posts(date);
CREATE INDEX idx_media_files_post ON public.media_files(post_id);

-- Row Level Security (RLS) 政策
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.media_files ENABLE ROW LEVEL SECURITY;

-- 用户只能访问自己的数据
CREATE POLICY "Users can view own profile" ON public.user_profiles
  FOR ALL USING (auth.uid() = id);

CREATE POLICY "Users can view own posts" ON public.posts
  FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "Users can view own media files" ON public.media_files
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM public.posts 
      WHERE posts.id = media_files.post_id 
      AND posts.user_id = auth.uid()
    )
  );

-- 创建存储桶（Storage Bucket）
INSERT INTO storage.buckets (id, name, public) 
VALUES ('media-files', 'media-files', true);

-- 存储桶访问政策
CREATE POLICY "Users can upload media files" ON storage.objects
  FOR INSERT TO authenticated
  WITH CHECK (bucket_id = 'media-files');

CREATE POLICY "Users can view media files" ON storage.objects
  FOR SELECT TO authenticated
  USING (bucket_id = 'media-files');

CREATE POLICY "Users can delete own media files" ON storage.objects
  FOR DELETE TO authenticated
  USING (bucket_id = 'media-files' AND auth.uid()::text = (storage.foldername(name))[1]);

-- 创建实时发布功能（Realtime）
ALTER PUBLICATION supabase_realtime ADD TABLE public.posts;
ALTER PUBLICATION supabase_realtime ADD TABLE public.media_files;