clear all
clc

%% Parameter 정의
% data_dim : 데이터 차원
% data_num : 데이터 크기
% lb, ub : 데이터 범위

%% data setting
data_num = 100
data_dim = 5

% lower boundary set
lb_set = [1, 1, 1, 1000, 20 ]
% lb_set = [1, 1, 10, 1, 30]

% upper boundary set
ub_set = [50, 30, 40, 5000, 50]
% ub_set = [100, 50, 40, 100, ]

% mean set
% mean_set = (lb_set+ub_set)/2
% mean_set = ub_set
mean_set = lb_set

%% considering x index
xall_idx = [1,2,3,4,5];

for xx11_idx=1:1:4
    for xx22_idx = xx11_idx+1:1:5
        xlook_idx = [xx11_idx,xx22_idx];
        xother_idx = setdiff(xall_idx,xlook_idx);
        
        %% data generation
        xlook_1_term = (ub_set(xlook_idx(1))-lb_set(xlook_idx(1)))/(data_num-1);
        xlook_2_term = (ub_set(xlook_idx(2))-lb_set(xlook_idx(2)))/(data_num-1);
        
        xlook_1 = lb_set(xlook_idx(1)):xlook_1_term:ub_set(xlook_idx(1));
        xlook_2 = lb_set(xlook_idx(2)):xlook_2_term:ub_set(xlook_idx(2));
        
        xother_data = mean_set(xother_idx);
        xother_1 = ones(data_num,1)*xother_data(1);
        xother_2 = ones(data_num,1)*xother_data(2);
        xother_3 = ones(data_num,1)*xother_data(3);
        
        xall_db = zeros(data_num, data_dim);
        xall_db(:,xlook_idx(1)) = xlook_1;
        xall_db(:,xlook_idx(2)) = xlook_2;
        xall_db(:,xother_idx(1)) = xother_1;
        xall_db(:,xother_idx(2)) = xother_2;
        xall_db(:,xother_idx(3)) = xother_3;
        xall_db_copy = xall_db;
        ydata = zeros(data_num,data_num);
        
        for x1di=1:1:data_num
            for x2di=1:1:data_num
                xall_db_copy(:,xlook_idx(1)) = xall_db(x1di,xlook_idx(1));
                xx1 = xall_db_copy(x2di,1);
                xx2 = xall_db_copy(x2di,2);
                xx3 = xall_db_copy(x2di,3);
                xx4 = xall_db_copy(x2di,4);
                xx5 = xall_db_copy(x2di,5);     
        %         yy = (xx1^2)*(xx2-3)+xx2^3+3*xx3+xx4+xx5;
        %         yy = (xx1-10)*(xx1-12)+(xx2-3)^3+xx3+xx4+xx5;
%                 yy = 2*(xx1^2)*(xx2-3)+xx2^3-3*(xx3^2)+3*(xx4/xx5);
%                 yy = ((xx1/2)^2)*(xx2-10)+xx2^2-4*(xx3^2)+50*(xx4/(xx5));
                yy = ((xx1)/(10*xx2))^3+xx2-50*(xx3^2/(xx4))+(xx4/5)+(xx5^2)
                ydata(x1di,x2di)=yy;
            end
        end
        
        %% data plotting
        [x1_grid, x2_grid] = meshgrid(lb_set(xlook_idx(1)):xlook_1_term:ub_set(xlook_idx(1)),  lb_set(xlook_idx(2)):xlook_2_term:ub_set(xlook_idx(2)));
        y_grid = griddata(xlook_2,xlook_1,ydata,x2_grid,x1_grid);
        data_grid = mesh(x2_grid, x1_grid, y_grid);
        data_grid.FaceColor = 'flat';
        hold on
        xlim([lb_set(xlook_idx(2)), ub_set(xlook_idx(2))]);
        ylim([lb_set(xlook_idx(1)), ub_set(xlook_idx(1))]);
        xlabel(sprintf('X%d',xlook_idx(2)));
        ylabel(sprintf('X%d',xlook_idx(1)));
        zlabel('Y');
        
        colormap(jet);
        cbar = colorbar;
        ylabel(cbar, 'Y');
        
        saveas(gcf, sprintf('lb_img_x%d_x%d.png',[xlook_idx(1) xlook_idx(2)]))
        rotate3d on;
        clf('reset')
    end
end



