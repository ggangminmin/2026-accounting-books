// Supabase Configuration
const SUPABASE_URL = 'https://albrnqpfwnykdlpvvliw.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFsYnJucXBmd255a2RscHZ2bGl3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njc1NjE4NTQsImV4cCI6MjA4MzEzNzg1NH0.jIkx_poj0l6MBv074Bbc3AgIgaggMwyXGKb63_X38V4';

// Initialize Supabase client
const supabaseClient = supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
