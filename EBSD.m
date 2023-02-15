fileName = [mtexDataPath filesep 'EBSD' filesep 'haliteT163MontagedData6MontagedMapData.ctf'];
ebsd = EBSD.load(fileName, 'convertEuler2SpatialReferenceFrame', 'setting 2');
ebsd_full = ebsd;
plot(ebsd, 'coordinates', 'on')
plot(ebsd('Halite'), ebsd('Halite').orientations)

%xmin,ymin,dx,dy
%region = [0.3, 0.1, 4.5, 1]*10^4;
%rectangle('position', region,'edgecolor','r','linewidth',2)
%ebsd = ebsd(inpolygon(ebsd,region));
%ebsd_region = ebsd;

[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd);
notIndexed = grains('notIndexed');

toRemove = notIndexed(notIndexed.grainSize ./ notIndexed.boundarySize<1);
ebsd(toRemove) = [];
[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd);
grains = smooth(grains, 5);
plot(ebsd, ebsd.orientations)
hold on
plot(grains.boundary,'lineWidth',2)
hold off
plot(grains, grains.meanOrientation)
grains_region = grains;

outerBoundary_id = any(grains.boundary.grainId==0,2);
grain_id = grains.boundary(outerBoundary_id).grainId;
grain_id(grain_id==0) = []; 
ebsd(grains(grain_id)) = [];
grains(grain_id) = [];
big_grains = grains(grains.equivalentRadius > 150);
plot(big_grains('Halite'), big_grains('Halite').meanOrientation)
histogram(big_grains.equivalentRadius)
xlabel('radius µm')
ylabel('number of grains')
%if want to export the statistics data -- export
Radius_data = big_grains.equivalentRadius;

%Grain orientaion spread compared to mean orientaion within each grain --
%export
gos = grains.GOS;
plot(grains, grains.GOS ./ degree)
mtexColorbar('title','GOS in degree')
