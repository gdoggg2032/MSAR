function [top10, TaiwanAndChineseSongSingers] = mySongStats(songList)
    [names, ~, ~] = unique({songList.artist});
    artistSongCount = [];
    for n = names
        bit1 = strcmp(n, '不詳');
        bit2 = strcmp(n, 'unknown');
        bit3 = strcmp(n, '老歌');
        bit = bit1 | bit2 | bit3;
        if bit
            continue;
        end
        c = sum(strcmp(n, {songList.artist}));
        artistSongCount = [artistSongCount; struct('name', n, 'songCount', c)];
    end
    artistSongCount = struct2cell(artistSongCount);
    
    [~, index] = sort([artistSongCount{2,:}], 'descend');
    artistSongCount = reshape({artistSongCount{:,index}}, 2, [])';
    countStruct = cell2struct(artistSongCount, {'name', 'songCount'}, 2);
    
    top10 = countStruct(1:10);
    
    TaiwaneseSingers = [];
    ChineseSingers = [];
    for i = 1 : length(songList)
        song = songList(i);
        bit1 = strcmp(song.artist, '不詳');
        bit2 = strcmp(song.artist, 'unknown');
        bit3 = strcmp(song.artist, '老歌');
        bit = bit1 | bit2 | bit3;
        if bit
            continue;
        end
        if strcmp(song.language, 'Taiwanese') == 1
            TaiwaneseSingers = [TaiwaneseSingers; {song.artist}];
        elseif strcmp(song.language, 'Chinese') == 1
            ChineseSingers = [ChineseSingers; {song.artist}];
        end
    end
    TaiwanAndChineseSongSingers = sort(intersect(TaiwaneseSingers, ChineseSingers));
    
    
    
    
    
        
        
        
    
    