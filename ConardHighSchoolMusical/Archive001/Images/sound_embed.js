document.write('<EMBED src="');
document.write(tlxSoundEmbedSrc);
document.write('" type="audio/mpeg"');
document.write(' hidden="true"  autostart="true"');
if (tlxSoundLoop) {
    document.write(' loop="true"></EMBED>');
} else {
    document.write(' loop="false"></EMBED>');
}