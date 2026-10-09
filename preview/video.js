// Encodes frames captured by capture.js into renders/lumina-run.mp4 (30 fps CFR).
const { execFileSync } = require('child_process');
execFileSync('ffmpeg', ['-y','-framerate','30','-i','frames/f%05d.png','-c:v','libx264','-pix_fmt','yuv420p','-crf','18','-preset','medium','-movflags','+faststart','renders/lumina-run.mp4'], {stdio:'inherit'});
console.log('ENCODED renders/lumina-run.mp4');
